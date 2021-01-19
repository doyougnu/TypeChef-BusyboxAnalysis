# What are the Different Modes?

Available modes are given in the [VSATMode](https://github.com/doyougnu/TypeChef/blob/dev/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMode.scala) enum.
By state of writing this document, the modes are:

(sw) = based on existing stop watch code

- Unknown: We set this mode everytime we are not sure what is actually happening in TypeChef or we could not identify a dedicated name for the current process.
- [ArgParse](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L32): Inside TypeChef, there is an elaborate argument parser.
We set the mode to ArgParse when this parser is run.
- [LoadFM](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L271) (sw): Identifies queries that were made when the feature model was loaded.
- [LoadAST](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L314) (sw): TypeChef can reuse the variational AST it computed earlier (if specified as argument). Queries that were made when parsing this AST from file have the mode LoadAST.
- Serialize: 
- [Lexing](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L332) (sw):
- [Parsing](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L342) (sw): Is only done when there was no AST that could be reused (see LoadAST).
- [TypeSystemInit](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L371): There are a few lines of code for configuring the creation of `CTypeSystemFrontend` depending on the TypeChef argument `typechecksa` (which I guess is short for `typecheckstaticanalysis`).
- [TypeChecking](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L387) (sw)
- [Interfaces](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L395) (sw)
- [WriteInterfaces](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L399) (sw)
- [CallGraph](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L407) (sw)
- [StaticAnalysis](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L421) (sw)

The modes are set in the [Frontend of TypeChef](https://github.com/doyougnu/TypeChef/blob/dev/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala) (look for invocations of `VSATMissionControl.setCurrentMode`).

We cannot give reliable information on what exactly these modes are but we oriented on the calls to `println` and `stopWatch.start` in the existing TypeChef code that indicated different phases of computation.

Hint: The modes `TypeSystemInit`, `TypeChecking`, `Interfaces`, `WriteInterfaces`, `CallGraph`, and `StaticAnalysis` were previously all considered as just `TypeChecking`.

TODO for Paul: The following line is unidentified but does a sat call: https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L306
