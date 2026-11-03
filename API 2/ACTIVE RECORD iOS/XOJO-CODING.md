# Xojo Coding Guidance

Do not modify this file. If you have your own project-specific guidance to add, put it in a separate file and link to it from AGENTS.md.

## Project Notes

This project is written in Xojo, and saved in Xojo text ("Xojo Project") format.

## Xojo Project File Info

Check the following repo for up to date xojo text project references: https://github.com/xojo/XojoProjectFormatReference

### Window controls and events

- When adding a project item, create its file first, then add it to the project manifest. Preserve existing project item IDs.
- Before finishing, check that all Xojo tags are balanced and that event signatures match the documented Xojo event signatures.
- Visible UI controls are always serialized in the window layout. For every control users should see or interact with, add a Begin Desktop... block inside Begin DesktopWindow, before its closing End. Adapt the block from a known-good window of the same control type. Do not create visible controls with New or AddControl at runtime. Runtime-created controls are only for controls that are intentionally temporary or cannot be represented in the layout.
- Put window events, methods, and properties inside #tag WindowCode. Put control event handlers in #tag Events ControlName blocks after #tag EndWindowCode, following the Desktop template’s format.
- For controls declared in the window file, use #tag Events for their event handlers. Don’t wire them with AddHandler unless the event source is created dynamically and can’t be declared in the window.
- Before finishing, run the project in Xojo and resolve every entry in XojoCompileErrors.txt.
- Before finishing, inspect the window file: confirm every visible control has a serialized Begin Desktop... block inside Begin DesktopWindow, and that no visible controls are created with New or AddControl in code.

## Documentation

Use this location for easier searching of Xojo docs: https://documentation.xojo.com/llms.txt

## Code Conventions

- When adding code to events or methods, make sure you review the parameters that are part of the signature.
- When providing code, ensure that the types of assignments match.
- When providing source code that contains class properties, always be sure to use the Property keyword.
- Use descriptive event handler names; avoid leaving default handler names when logic is non-trivial.
- Use `Try/Catch` (or `Exception` blocks) around I/O, network, and database calls.
- Comment any non-obvious platform-specific code (`#If TargetMacOS`, `#If TargetWindows`, etc.)

## Build & Run

- Xojo projects are typically built and run through the Xojo IDE, not the command line.
- Xojo is running in Agentic mode, so the user does not need to manually reload the project to reflect changes.
- You can ask Xojo to run the project to check for errors by creating a file in the project folder called "XojoRunProject.txt".
- After "XojoRunProject.txt" file disappears, the project has been run by Xojo and you should wait 5 to 10 seconds (depending on the size of the overall project) to see if the error file appears.
- If a file called "XojoCompileErrors.txt" exists, then it contains the compile errors.

## What NOT to Do

- **When actively running a debug build, do not make modifications to the xojo_project file**. Stop the debug first and then modify the project file.
- Don't rename `.xojo_project` internal IDs/identifiers, this can break IDE references.
- Don't commit `Build/` output, `.xojo_project` lock/backup files or `.xojo_uistate` files.