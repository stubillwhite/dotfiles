"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyMac = void 0;
const VSCodeKeyAbstract_1 = require("./VSCodeKeyAbstract");
class VSCodeKeyMac extends VSCodeKeyAbstract_1.VSCodeKeyAbstract {
    convert(intellijKeystroke) {
        return super
            .convert(intellijKeystroke)
            .replace(/meta/g, VSCodeKeyMac.VSCODE_META);
    }
}
exports.VSCodeKeyMac = VSCodeKeyMac;
VSCodeKeyMac.VSCODE_META = 'cmd';
//# sourceMappingURL=VSCodeKeyMac.js.map