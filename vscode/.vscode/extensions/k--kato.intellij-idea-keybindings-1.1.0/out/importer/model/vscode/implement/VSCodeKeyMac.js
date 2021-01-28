"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyMac = void 0;
const IntelliJKeymapXML_1 = require("../../intellij/implement/IntelliJKeymapXML");
const VSCodeKeyAbstract_1 = require("./VSCodeKeyAbstract");
class VSCodeKeyMac extends VSCodeKeyAbstract_1.VSCodeKeyAbstract {
    convert(intellijKeystroke) {
        return super.convert(intellijKeystroke).replace(IntelliJKeymapXML_1.IntelliJKeymapXML.INTELLIJ_META_KEY, VSCodeKeyMac.VSCODE_META);
    }
}
exports.VSCodeKeyMac = VSCodeKeyMac;
VSCodeKeyMac.VSCODE_META = 'cmd';
//# sourceMappingURL=VSCodeKeyMac.js.map