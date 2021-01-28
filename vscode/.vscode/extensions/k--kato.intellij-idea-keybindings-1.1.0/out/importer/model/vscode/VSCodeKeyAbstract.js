"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyAbstract = void 0;
const IntelliJSyntaxAnalyzer_1 = require("../../syntax-analyzer/IntelliJSyntaxAnalyzer");
class VSCodeKeyAbstract {
    constructor(os, intellijKeystrokeCustom = undefined, intellijKeystrokeRemove = undefined, vscodeKeyRemove = undefined) {
        this.os = os;
        if (intellijKeystrokeCustom && intellijKeystrokeCustom.first) {
            this.key = this.convert(intellijKeystrokeCustom.first);
            if (intellijKeystrokeCustom.second) {
                this.key += VSCodeKeyAbstract.VSCODE_SECOND_DELIMITER + this.convert(intellijKeystrokeCustom.second);
            }
            return;
        }
        if (intellijKeystrokeRemove) {
            this.key = VSCodeKeyAbstract.VSCODE_REMOVING_DELIMITER + this.convert(intellijKeystrokeRemove.first);
            if (intellijKeystrokeRemove.second) {
                this.key += VSCodeKeyAbstract.VSCODE_SECOND_DELIMITER + this.convert(intellijKeystrokeRemove.second);
            }
            return;
        }
        if (vscodeKeyRemove) {
            this.key = VSCodeKeyAbstract.VSCODE_REMOVING_DELIMITER + vscodeKeyRemove;
            return;
        }
        throw Error('No IntelliJ keystrokes found');
    }
    convert(intellijKeystroke) {
        IntelliJSyntaxAnalyzer_1.IntelliJSyntaxAnalyzer.INTELLIJ_TO_VSCODE_KEY.forEach((vscodeMeta, intellijMeta) => {
            intellijKeystroke = intellijKeystroke.replace(intellijMeta, vscodeMeta);
        });
        return intellijKeystroke;
    }
}
exports.VSCodeKeyAbstract = VSCodeKeyAbstract;
VSCodeKeyAbstract.VSCODE_REMOVING_DELIMITER = '-';
VSCodeKeyAbstract.VSCODE_SECOND_DELIMITER = ' ';
VSCodeKeyAbstract.VSCODE_DELIMITTER = '+';
//# sourceMappingURL=VSCodeKeyAbstract.js.map