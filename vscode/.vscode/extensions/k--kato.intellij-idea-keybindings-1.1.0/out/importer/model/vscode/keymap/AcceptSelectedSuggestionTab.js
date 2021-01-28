"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AcceptSelectedSuggestionTab = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class AcceptSelectedSuggestionTab {
    constructor() {
        this.command = "acceptSelectedSuggestion";
        this.when = "suggestWidgetVisible && textInputFocus";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "tab"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "tab"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "tab"),
        ];
    }
}
exports.AcceptSelectedSuggestionTab = AcceptSelectedSuggestionTab;
/*
{
  "key": "tab",
  "command": "acceptSelectedSuggestion",
  "when": "suggestWidgetVisible && textInputFocus"
}
*/
//# sourceMappingURL=AcceptSelectedSuggestionTab.js.map