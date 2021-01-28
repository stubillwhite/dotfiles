"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TriggerSuggest = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class TriggerSuggest {
    constructor() {
        this.command = "editor.action.triggerSuggest";
        this.when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "cmd+i"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "alt+escape"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "ctrl+space"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "cmd+i"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "alt+escape"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "ctrl+space"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "cmd+i"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "alt+escape"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "ctrl+space"),
        ];
    }
}
exports.TriggerSuggest = TriggerSuggest;
/*
{
  "key": "cmd+i",
  "command": "editor.action.triggerSuggest",
  "when": "editorHasCompletionItemProvider && textInputFocus && !editorReadonly"
}
{
  "key": "alt+escape",
  "command": "editor.action.triggerSuggest",
  "when": "editorHasCompletionItemProvider && textInputFocus && !editorReadonly"
}
{
  "key": "ctrl+space",
  "command": "editor.action.triggerSuggest",
  "when": "editorHasCompletionItemProvider && textInputFocus && !editorReadonly"
}
*/
//# sourceMappingURL=TriggerSuggest.js.map