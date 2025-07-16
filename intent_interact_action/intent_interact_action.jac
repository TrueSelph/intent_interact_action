import os;
import json;
import logging;
import traceback;
import from typing { Union }
import from logging {Logger}
import from jivas.agent.modules.agentlib.utils {Utils}
import from jivas.agent.action.actions { Actions }
import from jivas.agent.action.interact_action { InteractAction }
import from jivas.agent.action.agent_graph_walker { agent_graph_walker }


node IntentInteractAction(InteractAction) {
    # based on an utterance, classifies against registered intents

    # set up logger
    static has logger:Logger = logging.getLogger(__name__);

    has strict:bool = True; # if strict, only actions belonging to matched functions will be executed.
    has prompt:str = """
You are an intent classification model. Follow these steps to identify the intent of the MESSAGE using context from HISTORY. Provide only the final output:

1. For each key in ANCHOR_INDEX, review the associated list of statements (the value) and compare them against the MESSAGE.
2. Identify which list of statements most accurately reflects the intent of the MESSAGE.
3. If one or more strong alignments are identified, return the corresponding key or keys in a comma-separated format. If no clear alignments are found, return 'unclassified'.
4. If MESSAGE has no alignment and is generic (e.g., 'thanks', 'ok', 'got it') OR lacks actionable content return 'unclassified'.

MESSAGE:
{utterance}

ANCHOR_INDEX:
{anchor_index}

HISTORY:
{history}

""";
    has history_size:int = 5;
    has max_statement_length:int = 500;
    has model_action:str = "LangChainModelAction";
    has model_name:str = "gpt-4o";
    has model_temperature:float = 0.2;
    has model_max_tokens:int = 4096;
    has exceptions:list = ['FunctionInteractAction']; # list of actions which are included in intent, regardless


    def touch(visitor: agent_graph_walker) -> bool {
        # authorize the interact to run
        if visitor.utterance {
            return True;
        }
    }

    def execute(visitor: agent_graph_walker) -> None {

        # first, let's see if we have any defined anchors from any actions for classification
        anchor_index = self.get_anchor_index(visitor);

        if(anchor_index) {
            # grab the history
            history = visitor.frame_node.get_transcript(interactions = self.history_size, max_statement_length = self.max_statement_length, with_events = True);

            # prepare the prompt
            prompt_messages = [
                {"system": self.prompt}
            ];

            # set the prompt variables
            prompt_variables = {
                "anchor_index": Utils.escape_string(json.dumps(anchor_index)),
                "utterance": visitor.utterance,
                "history": history
            };

            result = None;

            if(model_action := self.get_agent().get_actions().get(action_label=self.model_action)) {

                if( model_action_result := model_action.call_model(
                    prompt_messages = prompt_messages,
                    prompt_variables = prompt_variables,
                    model_name = self.model_name,
                    model_temperature = self.model_temperature,
                    model_max_tokens = self.model_max_tokens,
                    interaction_node = visitor.interaction_node
                )) {

                    if (result := model_action_result.get_result()) {
                        # add the resulting intent, if any to the interaction to trigger the relevant action(s)
                        intents = result.split(",");
                        # update the intents
                        for intent in intents {
                            visitor.interaction_node.add_intent(intent);
                        }
                    }
                }
            }
        }
    }

    def get_anchor_index(visitor: agent_graph_walker) -> dict {
        # retrieves a dictionary of anchor statements from each action for classification; to be spawned on an agent
        anchor_index = {};

        # get a list of all interact actions
        all_actions = self.get_agent().get_actions().get_all(only_interact_actions=True, only_enabled=True);

        for action_node in all_actions {
            # only actions which implement anchors are of interest to us
            if(action_node.anchors and action_node.label != self.get_type()) {
                anchor_index[action_node.label] = action_node.anchors;
            }
        }

        return anchor_index;
    }

    def healthcheck() -> Union[bool, dict] {

        if(not self.prompt) {
            return {
                "status": False,
                "message": "Prompt not specified.",
                "severity": "error"
            };
        }

        if(not self.model_action) {
            return {
                "status": False,
                "message": "Model action not specified.",
                "severity": "error"
            };
        }

        if(not self.model_name) {
            return {
                "status": False,
                "message": "Model name not specified.",
                "severity": "error"
            };
        }

        model_action = self.get_agent().get_actions().get(action_label=self.model_action);
        if not model_action {
            return {
                "status": False,
                "message": f"Model Action is not registered. {self.model_action}",
                "severity": "error"
            };
        }

        return True;

    }

}
