"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeJsonParser = void 0;
const VSCodeKeybindingDefault_1 = require("../model/vscode/implement/VSCodeKeybindingDefault");
class VSCodeJsonParser {
    static async desirialize(json) {
        if (!json) {
            return [];
        }
        const vscodeKeybindings = new Array();
        JSON.parse(json).map((row) => {
            const vscodeKeybinding = new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(row.command, row.key, row.when);
            vscodeKeybindings.push(vscodeKeybinding);
        });
        return vscodeKeybindings;
    }
}
exports.VSCodeJsonParser = VSCodeJsonParser;
//# sourceMappingURL=VSCodeJsonParser.js.map