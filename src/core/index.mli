type fcvars

type error =
  | UnboundName          of Id.name
  | UnboundCtxName       of Id.name
  | UnboundCtxSchemaName of Id.name
  | UnboundCompName      of Id.name
  | UnboundCompConstName of Id.name
  | UnboundObs           of Id.name
  | PatCtxRequired
  | CompEmptyPattBranch
  | UnboundIdSub
  | PatVarNotUnique
  | IllFormedCompTyp
  | MisplacedOperator of Id.name
  | MissingArguments  of Id.name * int * int
  | ParseError
  | NoRHS
  | NameOvershadowing of Id.name

exception Error of Syntax.Loc.t * error

type free_cvars

val kind     : Syntax.Ext.LF.kind -> Syntax.Apx.LF.kind * fcvars

val typ      : Syntax.Ext.LF.typ -> Syntax.Apx.LF.typ * fcvars

val schema   : Syntax.Ext.LF.schema -> Syntax.Apx.LF.schema

val mctx     : Syntax.Ext.LF.mctx -> Syntax.Apx.LF.mctx  

val compkind : Syntax.Ext.Comp.kind -> Syntax.Apx.Comp.kind

val comptyp  : Syntax.Ext.Comp.typ -> Syntax.Apx.Comp.typ

val comptypdef : Syntax.Ext.Comp.typ * Syntax.Ext.Comp.kind
              -> Syntax.Apx.Comp.typ * Syntax.Apx.Comp.kind

val exp      : Store.Var.t -> Syntax.Ext.Comp.exp_chk -> Syntax.Apx.Comp.exp_chk

val exp'     : Store.Var.t -> Syntax.Ext.Comp.exp_syn -> Syntax.Apx.Comp.exp_syn

val hexp     : Store.CVar.t ->  Store.Var.t -> Syntax.Ext.Comp.exp_chk -> Syntax.Apx.Comp.exp_chk
