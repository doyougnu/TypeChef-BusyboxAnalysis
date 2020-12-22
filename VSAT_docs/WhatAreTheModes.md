# What are the Different Modes?

Available modes are given in the [VSATMode](https://github.com/doyougnu/TypeChef/blob/dev/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMode.scala) enum.
By state of writing this document, the modes are:

- Unknown
- ArgParse
- LoadFM
- LoadAST
- Serialize
- Lexing
- Parsing
- TypeSystemInit
- TypeChecking
- Interfaces
- WriteInterfaces
- CallGraph
- StaticAnalysis

The modes are set in the [Frontend of TypeChef](https://github.com/doyougnu/TypeChef/blob/dev/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala) (look for invocations of `VSATMissionControl.setCurrentMode`).

We cannot give reliable information on what exactly these modes are but we oriented on the calls to `println` and `stopWatch.start` in the existing TypeChef code that indicated different phases of computation.

Hint: The modes `TypeSystemInit`, `TypeChecking`, `Interfaces`, `WriteInterfaces`, `CallGraph`, and `StaticAnalysis` were previously all considered as just `TypeChecking`.