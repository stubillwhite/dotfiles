"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyAbstract = void 0;
class VSCodeKeyAbstract {
    constructor(intellijKeymap, keystrokeKeyMappings) {
        this.keystrokeKeyMappings = keystrokeKeyMappings;
        this.key = this.convert(intellijKeymap.first);
        if (intellijKeymap.second) {
            this.key += VSCodeKeyAbstract.VSCODE_SECOND_DELIMITER + this.convert(intellijKeymap.second);
        }
    }
    convert(intellijKeystroke) {
        this.keystrokeKeyMappings.forEach(mapping => {
            intellijKeystroke = intellijKeystroke.replace(mapping.intellij, mapping.vscode);
        });
        return intellijKeystroke;
    }
}
exports.VSCodeKeyAbstract = VSCodeKeyAbstract;
VSCodeKeyAbstract.VSCODE_SECOND_DELIMITER = ' ';
//# sourceMappingURL=VSCodeKeyAbstract.js.map