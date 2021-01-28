"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AcceptSelectedSuggestionEnter = void 0;
const VSCodeKeyDefault_1 = require("../VSCodeKeyDefault");
class AcceptSelectedSuggestionEnter {
    constructor() {
        this.command = "acceptSelectedSuggestion";
        this.when = "suggestWidgetVisible && textInputFocus";
        this.keysDefault = [
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Linux", "enter"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Mac", "enter"),
            new VSCodeKeyDefault_1.VSCodeKeyDefault("Windows", "enter"),
        ];
    }
}
exports.AcceptSelectedSuggestionEnter = AcceptSelectedSuggestionEnter;
/*
{
  "key": "enter",
  "command": "acceptSelectedSuggestion",
  "when": "acceptSuggestionOnEnter && suggestWidgetVisible && suggestionMakesTextEdit && textInputFocus"
}
*/
//# sourceMappingURL=AcceptSelectedSuggestionEnter.js.map