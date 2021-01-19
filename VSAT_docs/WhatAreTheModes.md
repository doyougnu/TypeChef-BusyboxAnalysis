# What are the Different Modes?

Available modes are given in the [VSATMode](https://github.com/doyougnu/TypeChef/blob/dev/FeatureExprLib/src/main/scala/de/fosd/typechef/featureexpr/sat/VSATMode.scala) enum.
By state of writing this document, the modes are:

(vsat) = mode introduced by us
(tcsw) = mode based on TypeChef's existing stop watch code

- (vsat) Unknown:
We set this mode every time we are not sure what is actually happening in TypeChef or we could not identify a dedicated name for the current process.
So queries under mode Unknown are queries that were made in TypeChef at a point in time that we could not surely identify as a specific action.
- (vsat) [ArgParse](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L32): Inside TypeChef, there is an elaborate argument parser.
We set the mode to ArgParse when this parser is run.
- (tcsw) [LoadFM](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L271):
Identifies queries that were made when the feature model was loaded.
- (tcsw) [LoadAST](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L314):
TypeChef can reuse the variational AST it computed earlier (if specified as argument).
Queries that were made when parsing this AST from file have the mode LoadAST.
- (tcsw) [Serialize](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L357):
If parsing has happened and `serializeAST` is set to true in arguments, the parsed AST is written to file during this mode.
- (tcsw) [Lexing](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L332):
self explanatory
- (tcsw) [Parsing](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L342):
Is only done when there was no AST that could be reused (see LoadAST).
- (vsat) [TypeSystemInit](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L371):
There are a few lines of code for configuring the creation of `CTypeSystemFrontend` depending on the TypeChef argument `typechecksa` (which I guess is short for `typecheckstaticanalysis`).
- (tcsw) [TypeChecking](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L387):
self explanatory
- (tcsw) [Interfaces](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L395):
The paper [_A Variability-Aware Module System_](http://www.cs.cmu.edu/~ckaestne/pdf/oopsla12.pdf) talks about interfaces but I don't know yet if this is what this mode is about.
- (tcsw) [WriteInterfaces](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L399):
Seems to be writing that which was computed during mode Interfaces to file.
- (tcsw) [CallGraph](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L407):
There was a paper for this but on Web applications: https://www.cs.cmu.edu/~ckaestne/pdf/fse14.pdf.
I don't know if this is supported for C/C++ code.
- (tcsw) [StaticAnalysis](https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L421):
self explanatory.
Could be subdivided into different independent static analysis.
Might be interesting for the future.

The modes are set in the [Frontend of TypeChef](https://github.com/doyougnu/TypeChef/blob/dev/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala) (look for invocations of `VSATMissionControl.setCurrentMode`).

We cannot give reliable information on what exactly these modes are but we oriented on the calls to `println` and `stopWatch.start` in the existing TypeChef code that indicated different phases of computation.

The modes that are used in the Busybox-Analysis are:
ArgParse,
CallGraph,
Interfaces,
Lexing,
LoadFM,
Parsing,
TypeChecking, and
Unknown

Hint: The modes `TypeSystemInit`, `TypeChecking`, `Interfaces`, `WriteInterfaces`, `CallGraph`, and `StaticAnalysis` were previously all considered as just `TypeChecking`.

TODO for Paul: The following line is unidentified but does a sat call: https://github.com/doyougnu/TypeChef/blob/3e67d9355dba59b23431a99bfc53d5042e6bd454/Frontend/src/main/scala/de/fosd/typechef/Frontend.scala#L306
