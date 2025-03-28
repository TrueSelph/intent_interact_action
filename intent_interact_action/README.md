# Intent Interact Action

![GitHub release (latest by date)](https://img.shields.io/github/v/release/TrueSelph/intent_interact_action)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/TrueSelph/intent_interact_action/test-intent_interact_action.yaml)
![GitHub issues](https://img.shields.io/github/issues/TrueSelph/intent_interact_action)
![GitHub pull requests](https://img.shields.io/github/issues-pr/TrueSelph/intent_interact_action)
![GitHub](https://img.shields.io/github/license/TrueSelph/intent_interact_action)

The **Intent Interact Action** is an advanced interact action designed for classifying natural language utterances against registered intents, subsequently enriching the interaction process by adding corresponding intents (actions) dynamically. It serves as an essential component within the core action group, enabling accurate intent detection and interaction enhancement within conversational flows.

## Package Information

- **Name:** `jivas/intent_interact_action`
- **Author:** [V75 Inc.](https://v75inc.com/)
- **Architype:** `IntentInteractAction`
- **Version:** `0.0.1`

## Meta Information

- **Title:** Intent Interact Action
- **Description:** Classifies an utterance against registered intents; adds one or more intents (actions) to interaction.
- **Group:** core
- **Type:** interact_action

## Configuration

- **Singleton:** `true`
- **Order:**
  - **Weight:** `-10`
  - **Before:** `all`

## Dependencies

- **Jivas:** `^2.0.0`
- **Actions:**
  - [`jivas/langchain_model_action`](https://github.com/TrueSelph/langchain_model_action): `^0.0.1`

---

## How To Configure

This guide details how you can properly configure the `intent_interact_action` for optimal and targeted functionality within your deployment.

### Basic Configuration Options

The `intent_interact_action` is highly configurable to fit your interaction requirements. The key configuration parameters are explained below:

- **strict** (`bool`, default=`true`):  
  If enabled, only actions associated with explicitly matched intents from the provided anchors will be executed. Disable strict mode (`strict=False`) to execute other available actions by default, even if their intents are not directly matched.

- **exceptions** (`list`, default=`['FunctionInteractAction']`):  
  When in strict mode, this list specifies action node names to always include, regardless of intent matching outcomes.  
  Users can add additional node names to ensure certain actions consistently execute despite strict intent classification, e.g.:  
  ```yaml
  exceptions:
    - FunctionInteractAction
    - CustomAlwaysRunAction
  ```

### Configuring the Language Model

The Intent Interact Action leverages a chosen language model to provide context-aware inferencing and classify intents from conversational history. The following parameters ensure you optimize performance and accuracy of intent inference:

```yaml
history_size: 5                 # Recent exchanges considered in analysis
max_statement_length: 500       # Maximum input statement length (tokens/chars)
model_action: LangChainModelAction  # Node that supplies the LLM inference capability
model_name: gpt-4o              # LLM model utilized for intent detection
model_temperature: 0.2          # Controls inference determinism (low value = more deterministic)
model_max_tokens: 2048          # Maximum tokens allowed in LLM response
```

Alter the values above to align with your platform resources, conversational context requirements, response speed, and accuracy precision requirements.

### Configuring Anchors for Intent Actions

The `IntentInteractAction` can interface and trigger any interact action within the pipeline by means of anchors declared in respective actions. An anchor signals the intent under which an action is executed. Below is an example of anchor definitions:

```yaml
anchors:
  - "MESSAGE is a query requesting the traffic report"
  - "MESSAGE is a query relating to the bridge retraction schedule"
```

Anchors must succinctly describe intents for reliable inferencing and should clearly specify the conditions for triggering the associated action.

---

### Example YAML Configuration

Here's a comprehensive example demonstrating standard configuration usage:

```yaml
intent_interact_action:
  strict: true
  exceptions:
    - FunctionInteractAction
    - WeatherInteractAction
  history_size: 5
  max_statement_length: 500
  model_action: LangChainModelAction
  model_name: gpt-4o
  model_temperature: 0.2
  model_max_tokens: 2048
```

---

### Best Practices

- Ensure intent definitions (anchors) are clearly phrased to facilitate accurate classification.
- Evaluate and retrain language models periodically, maintaining high intent-detection accuracy.
- Test intent interactions thoroughly in staging environments before production deployment.
- Stay mindful of configured resource limits, ensuring prompt and efficient performance.

---

## 🔰 Contributing

- **🐛 [Report Issues](https://github.com/TrueSelph/intent_interact_action/issues)**: Submit bugs or suggest enhancements for the `intent_interact_action` project.
- **💡 [Submit Pull Requests](https://github.com/TrueSelph/intent_interact_action/blob/main/CONTRIBUTING.md)**: Contribute improvements or fixes by opening your own pull requests.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the repository to your GitHub account.
2. **Clone Locally**: Clone your fork locally using git:
   ```sh
   git clone https://github.com/jivas/intent_interact_action
   ```
3. **Create a Branch**: Work on a new branch with a clear, descriptive name.
   ```sh
   git checkout -b feature-intent-classifier
   ```
4. **Make Your Changes**: Develop and thoroughly test your changes.
5. **Commit clearly**: Use descriptive commit messages to document your updates.
   ```sh
   git commit -m 'Enhanced intent classification accuracy'
   ```
6. **Push your branch**: Push changes to your forked repository.
   ```sh
   git push origin feature-intent-classifier
   ```
7. **Open a Pull Request**: Submit a PR detailing your changes and their rationale.
8. **Review Cycle**: Once reviewed and approved, your contribution will be merged. Thank you for contributing!
</details>

<details open>
<summary>Contributor Graph</summary>
<br>
<p align="left">
    <a href="https://github.com/TrueSelph/intent_interact_action/graphs/contributors">
        <img src="https://contrib.rocks/image?repo=TrueSelph/intent_interact_action" />
   </a>
</p>
</details>

## 🎗 License

This project is licensed under the terms of the Apache License 2.0. Refer to the [LICENSE](../LICENSE) for details.