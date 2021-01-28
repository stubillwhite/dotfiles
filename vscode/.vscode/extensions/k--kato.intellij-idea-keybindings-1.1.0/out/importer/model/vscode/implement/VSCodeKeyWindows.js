"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyWindows = void 0;
const IntelliJKeymapXML_1 = require("../../intellij/implement/IntelliJKeymapXML");
const VSCodeKeyAbstract_1 = require("./VSCodeKeyAbstract");
class VSCodeKeyWindows extends VSCodeKeyAbstract_1.VSCodeKeyAbstract {
    convert(intellijKeystroke) {
        return super
            .convert(intellijKeystroke)
            .replace(IntelliJKeymapXML_1.IntelliJKeymapXML.INTELLIJ_META_KEY, VSCodeKeyWindows.VSCODE_META);
    }
}
exports.VSCodeKeyWindows = VSCodeKeyWindows;
VSCodeKeyWindows.VSCODE_META = 'win';
//# sourceMappingURL=VSCodeKeyWindows.js.map