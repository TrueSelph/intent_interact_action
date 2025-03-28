"""Tests for IntentInteractAction."""

import os


class TestIntentInteractAction:
    """Tests for IntentInteractAction."""

    def test_intent_interact_action(self) -> None:
        """Test IntentInteractAction."""

        from jaclang import jac_import
        from jaclang.runtimelib.context import ExecutionContext

        os.environ["JACPATH"] = "./"

        # load the JAC application
        jctx = ExecutionContext.create()

        filename = os.path.join(
            os.path.dirname(__file__),
            "..",
            "intent_interact_action.jac",
        )

        base, mod = os.path.split(filename)
        base = base if base else "./"
        mod = mod[:-4]

        jac_import(
            target=mod,
            base_path=base,
            cachable=True,
            override_name="__main__",
        )

        jctx.close()

        del os.environ["JACPATH"]
