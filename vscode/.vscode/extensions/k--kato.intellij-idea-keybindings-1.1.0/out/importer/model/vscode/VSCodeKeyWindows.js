"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyWindows = void 0;
const VSCodeKeyAbstract_1 = require("./VSCodeKeyAbstract");
class VSCodeKeyWindows extends VSCodeKeyAbstract_1.VSCodeKeyAbstract {
    convert(intellijKeystroke) {
        return super
            .convert(intellijKeystroke)
            .replace(/meta/g, VSCodeKeyWindows.VSCODE_META);
    }
}
exports.VSCodeKeyWindows = VSCodeKeyWindows;
VSCodeKeyWindows.VSCODE_META = 'win';
//# sourceMappingURL=VSCodeKeyWindows.js.map