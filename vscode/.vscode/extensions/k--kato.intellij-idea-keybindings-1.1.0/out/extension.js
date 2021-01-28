"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = void 0;
const vscode = require("vscode");
const KeybindingsJsonGenerator_1 = require("./importer/generator/KeybindingsJsonGenerator");
const ActionIdCommandMappingJsonParser_1 = require("./importer/parser/ActionIdCommandMappingJsonParser");
const IntelliJXmlParser_1 = require("./importer/parser/IntelliJXmlParser");
const KeystrokeKeyMappingJsonParser_1 = require("./importer/parser/KeystrokeKeyMappingJsonParser");
const VSCodeJsonParser_1 = require("./importer/parser/VSCodeJsonParser");
const FileOpenDialog_1 = require("./importer/reader/FileOpenDialog");
const FileReaderDefault_1 = require("./importer/reader/FileReaderDefault");
const Picker_1 = require("./importer/reader/Picker");
const IntelliJSyntaxAnalyzer_1 = require("./importer/syntax-analyzer/IntelliJSyntaxAnalyzer");
const FileOpen_1 = require("./importer/writer/FileOpen");
function activate(context) {
    vscode.commands.registerCommand('IntelliJ/importFile', async function () {
        /*---------------------------------------------------------------------
         * Reader
         *-------------------------------------------------------------------*/
        const os = await Picker_1.Picker.pickOSDestionation();
        if (!os) {
            return;
        }
        const intellijXmlCustom = await FileOpenDialog_1.FileOpenDialog.showXml();
        const intellijXmlDefault = await FileReaderDefault_1.FileReaderDefault.readIntelliJ(os.src, context);
        const vscodeJsonDefault = await FileReaderDefault_1.FileReaderDefault.readVSCode(os.src, context);
        const actionIdCommandMappingJson = await FileReaderDefault_1.FileReaderDefault.readActionIdCommandMapping(context);
        const keystrokeKeyMappingJson = await FileReaderDefault_1.FileReaderDefault.readKeystrokeKeyMapping(context);
        /*---------------------------------------------------------------------
         * Parser
         *-------------------------------------------------------------------*/
        const intellijJsonCustom = (intellijXmlCustom)
            ? await IntelliJXmlParser_1.IntelliJXMLParser.parseToJson(intellijXmlCustom)
            : undefined;
        const intellijJsonDefault = await IntelliJXmlParser_1.IntelliJXMLParser.parseToJson(intellijXmlDefault);
        const intellijCustoms = (intellijXmlCustom)
            ? await IntelliJXmlParser_1.IntelliJXMLParser.desirialize(intellijJsonCustom)
            : [];
        const intellijDefaults = await IntelliJXmlParser_1.IntelliJXMLParser.desirialize(intellijJsonDefault);
        const vscodeDefaults = await VSCodeJsonParser_1.VSCodeJsonParser.desirialize(vscodeJsonDefault);
        const actionIdCommandMappings = await ActionIdCommandMappingJsonParser_1.ActionIdCommandMappingJsonParser.desirialize(actionIdCommandMappingJson);
        const keystrokeKeyMappings = await KeystrokeKeyMappingJsonParser_1.KeystrokeKeyMappingJsonParser.desirialize(keystrokeKeyMappingJson);
        /*---------------------------------------------------------------------
         * Semantic Analyzer
         *-------------------------------------------------------------------*/
        const syntaxAnalyzer = new IntelliJSyntaxAnalyzer_1.IntelliJSyntaxAnalyzer(os.dst, intellijDefaults, intellijCustoms, vscodeDefaults, actionIdCommandMappings, keystrokeKeyMappings);
        const keybindings = await syntaxAnalyzer.convert();
        /*---------------------------------------------------------------------
         * Code Generator
         *-------------------------------------------------------------------*/
        const keybindingsJson = await KeybindingsJsonGenerator_1.KeybindingsJsonGenerator.gene(keybindings);
        /*---------------------------------------------------------------------
         * Writer
         *-------------------------------------------------------------------*/
        const untitledKeybindingsJson = await FileOpen_1.FileOpen.openText(keybindingsJson);
        await FileOpen_1.FileOpen.showKeybindingsJson(untitledKeybindingsJson);
    });
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map