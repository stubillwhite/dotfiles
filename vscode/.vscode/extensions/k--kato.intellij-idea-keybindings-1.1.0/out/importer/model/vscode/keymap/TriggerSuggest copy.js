"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TriggerSuggest = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class TriggerSuggest {
    constructor() {
        this.command = "editor.action.triggerSuggest";
        this.when = "editorHasCompletionItemProvider && textInputFocus && !editorReadonly";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", ["cmd+i", "alt+escape", "ctrl+space"]),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", ["cmd+i", "alt+escape", "ctrl+space"]),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", ["cmd+i", "alt+escape", "ctrl+space"]),
        ];
    }
}
exports.TriggerSuggest = TriggerSuggest;
//# sourceMappingURL=TriggerSuggest%20copy.js.map