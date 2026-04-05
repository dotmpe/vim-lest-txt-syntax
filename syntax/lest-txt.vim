" Id: vim-lest.txt/0.1-dev lest-txt.vim
" File: syntax/lest-txt.vim
" Description: Text list syntax settings
" Author: B. van Berkum <dev@dotmpe.com>
" License: Vim license
" Website: http://github.com/dotmpe/vim-lest.txt
" Version: 0.1.3-dev

if exists("b:current_syntax")
 finish
endif

" Lets simplify this a bit
"syntax case ignore

" Introduce our pre-processor directives as new keywords
" XXX:
"syntax keyword PreProc #incl[ude] #cols #columns #sch[eme]


""" Region, match and cluster definitions

" Basic comment line, does not match directives

" FIXME: what scope and file should parameters go...
let allow_empty_comments = 0

syntax match HashCommentLineEmpty '^ *#\+ *$'
if allow_empty_comments
  syntax match HashCommentLine '^ *#\+\( .\+\)\?$' contains=@PlainTag,@EntryFields
else
  syntax match HashCommentLine '^ *#\+ .\+$' contains=@PlainTag,@EntryFields
endif

syntax match HighPriorityId '([1-2a-h][0-9 \.-]\+)' contained contains=NumeralId
syntax match MedPriorityId '([3-5i-p][0-9 \.-]\+)' contained contains=NumeralId
syntax match LowPriorityId '([6-9q-z][0-9 \.-]\+)' contained contains=NumeralId
syntax match UnPriorityId '(0[0-9 \.-]\+)' contained contains=NumeralId
syntax cluster PriorityId contains=HighPriorityId,MedPriorityId,LowPriorityId,UnPriorityId

syntax match HexNumeralId '[ :=]\zs[0-9bx\.\+-][0-9a-fei,/^\.\+-]\+' contained
syntax match NumeralId '[ :=(]\zs[0-9b\.\+-]*[0-9][0-9ei,/^\.\+-]*\>' contained
syntax match FieldId '[A-Za-z0-9 \.-]\+' contained

"syntax cluster StatFields contains=@PriorityId
" XXX: deprecate?
syntax cluster EntryFields contains=@PriorityId,@QuotedValue,GlobalRef,GlobalCite,ClassTag,PlainTag,HashTag,ProjectTag,PathField,MetaField,VarField,NumeralId
syntax cluster ClosedEntry contains=ClassTag,PathField,NumeralId,LineContinuation
 
syntax match ClosedEntry '^ *x .*$' contains=@ClosedEntry
"syntax match CommentEntry '^ *#- .*$' contains=@EntryFields
syntax match CommentEntry '^ *# [A-Za-z0-9 \.-]\+: .*$' contains=@PlainTag,FieldId,@EntryFields
syntax match IndentedEntry '^ \+.*$' contains=@PlainTag,ListStat,@EntryFields

"syntax cluster ListEntryFields contains=MetaTag,MetaValue,PlainTag


syntax cluster PlainTag contains=PlainTODO,PlainFIXME,PlainXXX,PlainBUG,PlainNOTE
syntax match PlainBUG '\<BUG\>' contained
syntax match PlainFIXME '\<FIXME\>' contained
syntax match PlainNOTE '\<NOTE\>' contained
syntax match PlainTODO '\<TODO\>' contained
syntax match PlainXXX '\<XXX\>' contained

syntax cluster SymRef contains=GLobalRef,GlobalCite,HashTag,ProjectTag,ClassTag
syntax match ClassTag '@[A-Za-z_][A-Za-z0-9+:\./_-]\+' contained contains=MetaField
syntax match ProjectTag '+[A-Za-z_][A-Za-z0-9_-]\+' contained
syntax match HashTag '#[A-Za-z_][A-Za-z0-9_-]\+' contained
syntax match GlobalRef '<[^>]\+>' contained
syntax match GlobalCite '\[[^\]]\+\]' contained

" Intended text/data blocks
syntax match BlockData '^  *.*$' contained contains=HeaderLine,FieldLine,Bq,CmdLine,DotpathF,ClassTag,ProjectTag,GlobalRef,GlobalCite,DotPathF,DotNameF,BlockText,BlockPunct
"syntax match BlockText '[A-Za-z0-9_]\+' contained
syntax match BlockPunct '\(\.\_s\)\|[^\ \.@\+\[<A-Za-z0-9_]' contained
"syntax cluster BlockElements contains=Bq,CmdLine

sy match DotPathRel '\.\+[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\(\.[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\)\+\ze\_s\?' contained contains=DotPath,DotNameF
sy match DotPath '[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\(\.[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\)\+\ze\_s\?' contained contains=EntityName,Dot
sy match DotPathF '\(^\|\s\)\zs[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\(\.[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\)\+\ze\_s' contains=EntityName,Dot
sy match DotName '\.[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]' contained contains=EntityName,Dot
sy match DotNameF '\(^\|\s\)\zs\.[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]\ze\_s' contains=EntityName,Dot
sy match Dot '\.' contained
sy match EntityName '[a-z0-9][a-z0-9-]\{0,30\}[a-z0-9]' contained

" ArgVar is same as GlobalRef
syntax match ArgWord '[^ ]\+' contained
syntax match ArgVar '<[^>]\+>' contained
syntax match ArgOptional '\[[^\]]\+\]' contained 
syntax match CmdLine '^ *% .*' contains=CmdLinePrefix,ArgWord,ArgVar,ArgOptional
syntax match CmdLinePrefix '^ * % [^ ]\+' contains=CmdLineSym,CmdName
syntax match CmdName ' \ze[^ ]\+'
syntax match CmdLineSym '^ * % ' contains=BlockLinePunct

" Blockquote as in old MIME email text formatting
syntax match Bq '^ *> .*$' contains=BqPrefix,@SymRef,@PlainTag
syntax match BqPrefix '^ * > ' contains=BlockLinePunct

syntax match FieldLine '^  *[^ ]\+:\ze\_s' contains=BlockLinePunct

syntax match BlockLinePunct '[:\$%&>\|-]'

" Headers in (indented) blocks
syntax match HeaderLine '^  *\#\+ [^ ]\+.*$' contains=Header
syntax match Header '\#\+\zs[^\n]\+' contained
" Lists
syntax match ListLine '^  *[\*-] '

syntax match MetaField '[^ ]\+:[^: ]\+:\?\_s' contained contains=MetaTag,MetaValue,VarField
syntax match MetaTag '[A-Za-z0-9_-]\+:' contained
syntax match MetaValue '[^: ]\+\_s' contained contains=@QuotedValue,PathField

syntax match PathField '[A-Za-z0-9\./_-]\+/[A-Za-z0-9_-]\+/\?' contained contains=PathName
syntax match PathName '[A-Za-z0-9_-]\+\_s' contained

syntax match VarField ' \zs[A-Za-z0-9_\./\$\&-]\+=[^ ]*\ze\_s' contained contains=VarValue,VarTag,VarPath
syntax match VarPath  '[A-Za-z0-9_\.-]\+\ze=' contained contains=VarTag,DotPath
syntax match VarTag   '[A-Za-z0-9_-]\+=\@=' contained
syntax match VarValue '=\@=[^ ]*' contained contains=DotName,DotPath


syntax cluster QuotedValue contains=@SingleQuoted,@AngleQuoted,@DoubleQuoted
syntax cluster SingleQuoted contains=Quoted,Quoted3
syntax cluster AngleQuoted contains=QuotedAngle,QuotedAngle3
syntax cluster DoubleQuoted contains=QuotedDouble,QuotedDouble3

" FIXME: should be using regions here
" Colour quoted values serpatedly at various levels
syntax match Quoted '\s*\zs\'[^\']*\'' contained
syntax match Quoted3 '\s*\zs\'\'\'[^\']*\'\'\'' contained
syntax match QuotedAngle '\s*\zs`[^`]*`' contained
syntax match QuotedAngle3 '\s*\zs```[^`]*```' contained
syntax match QuotedDouble '\s*\zs"[^"]*"' contained
syntax match QuotedDouble3 '\s*\zs"""[^"]*"""' contained

syntax match LineContinuation '\\$'
" XXX: for C-mode preprocessed data may be...
syntax match LineContinuation '\\\\$'

syntax match HashOutlineLineEmpty '^#!\+ *$'
if allow_empty_comments
  syntax match HashOutlineLine '^#!\+ \( .\+\)\?$' contains=@PlainTag,HashTag,ProjectTag,ClassTag
else
  syntax match HashOutlineLine '^#!\+ .\+$' contains=@PlainTag,HashTag,ProjectTag,ClassTag
endif

syntax match ShebangLine '^#\![^ ].\+$'

syntax match HashDirectiveLine '^#[^A-Za-z_ ][A-Za-z_]\+.*$'

" Directives always at start of line, and are not comments
syntax match HashKeywordDirectiveLine '^#[A-Za-z_]\+.*$' contains=@ListDirType,ListDirArgument

syntax cluster ListDirType contains=ListDirTypeIncl,ListDirTypeCols,ListDirTypeSch

syntax match ListDirTypeIncl '\<incl\(ude\)\?\>' contained
syntax match ListDirTypeCols '\<col\(umn\)\?s\>' contained
syntax match ListDirTypeSch '\<sch\(eme\)\?\>' contained

syntax match ListDirArgument ' [^ ]\+$' contained contains=@ListDirRefTypes

syntax cluster ListDirRefTypes contains=ListDirValLookupRef,ListDirValTitleRef,ListDirValTagRef

syntax match ListDirValLookupRef '<\zs[^>]\+' contained
syntax match ListDirValTitleRef '"\zs[^"]\+' contained
syntax match ListDirValTagRef '[A-Za-z_][A-Za-z0-9_-]\+' contained

"syntax match ListVId '[A-Za-z_][A-Za-z0-9_-]\+\W\+' contained contains=ListNumeric,ListNumerals

"syntax match ListNumeric '\(^\|\W\)[0-9][0-9,\/\.\+-]*\($\|\W\|[A-Za-z0-9\/\^]\{1,9\}\)' contains=ListNumeral
"syntax match ListNumeric '[0-9][0-9,\/\.\+-]*\($\|\W\|[A-Za-z0-9\/\^]\{1,9\}\)' contains=ListNumeral
syntax match ListNumeral '[0-9]\+' contained

sy region ListEntryBlock start='^[0-9:,\.+-]' end='\n\+\ze[^ ]' contains=ListRecord,ListStatEntryId,BlockData

sy match ListStatEntryId  '^[0-9e:,\.+-][0-9e:,\.+ -]*\(\([^:]\+:\)\|[A-Za-z0-9_/\.-]\+\)\ze\_s' contained contains=ListStat,ListEntryId nextgroup=ListRecord
sy match ListStat         '^[0-9e:,\.+-][0-9e:,\.+ -]*\ze ' contained contains=ListRelTimeSpec,ListDateTime,ListDate,ListStatNA nextgroup=ListEntryId
sy match ListEntryId      ' \zs\(\([^:]\+\ze:\)\|[A-Za-z0-9_/\.-]\+\ze\)\_s' contained contains=IdPrefix,LineContinuation nextgroup=ListRecord
"syntax match IdPrefix    '[^ ]\{2,\}\ze:\?\s_' contained
sy match ListRecord       ' \zs.*$' contained contains=@EntryFields,LineContinuation

sy match ListStatNA       '\(^\| \)\zs-' contained
sy match ListRelTimeSpec  '\(^\| \)\zs-\d\{4\}\(+\d\d\)\?\ze ' contained transparent contains=ListStatPunct
sy match ListDateTime     '\(^\| \)\zs\d\{4\}-\d\d-\d\d\|\d\{8\}-\d\{4\}\([+-]\d\d\)\?\ze ' contained transparent contains=ListStatPunct
sy match ListDate         '\(^\| \)\zs\d\{4\}-\d\d-\d\d\|\d\{8\}\ze ' contained transparent contains=ListStatPunct

"sy match ListDateTime    '\(^\| \)\zs\d\{8\}\ze ' contained

sy match ListStatPunct    '[:,\.+-]' contained

""" Highight links


" Re-assign standard Vim link groups
"highlight link PreProc SignColumn
"highlight link PreProc Number
"highlight default link PreProc SpecialComment


" Assign our matches and regions to syntax highlight groups

highlight default link CommentEntry Comment
highlight default link ClosedEntry Comment
highlight default link ShebangLine Decorator
highlight default link HashOutlineLine Decorator
highlight default link HashCommentLine Comment
highlight default link HashCommentLineEmpty Warning
highlight default link HashOutlineLineEmpty Warning
highlight default link HashDirectiveLine Macro
highlight default link HashKeywordDirectiveLine PreProc

if $VIM_THEME =~ "nord"
highlight link LineContinuation XtermRed3
highlight link HashCommentLineEmpty XtermOrangeRed1
highlight link HashOutlineLineEmpty XtermOrangeRed1
else
highlight default link LineContinuation WarningSign
endif

"highlight default link @ListDirType SpecialKey
highlight default link ListDirTypeCols SpecialKey
highlight default link ListDirTypeIncl SpecialKey
highlight default link ListDirTypeSch SpecialKey
highlight default link ListDirArgument Special
highlight default link ListDirValLookupRef Identifier
highlight default link ListDirValTitleRef String
highlight default link ListDirValTagRef Identifier

highlight default link ListDate SpecialKey
highlight default link ListStatPunct Type
highlight default link ListNumeric Number
highlight default link ListNumeral Type

highlight default link UnPriorityId Warning
highlight default link MedPriorityId IncSearch
highlight default link HighPriorityId Search
highlight default link LowPriorityId Special
highlight default link NumeralId Number
highlight default link HexNumeralId Number

highlight default link ListStatEntryId FoldColumn
highlight default link ListEntryId Directory
highlight default link IdPrefix Type

highlight default link Quoted String
highlight default link Quoted3 String
highlight default link QuotedAngle String
highlight default link QuotedAngle3 String
highlight default link QuotedDouble String
highlight default link QuotedDouble3 String

highlight default link ListStat SpecialKey
highlight default link ListStatNA PreProc
highlight default link ListVId Type
highlight default link ListLine Comment

highlight default link HeaderLine Special
highlight default link Header CursorLineNr

highlight default link HashTag Character
highlight default link ProjectTag SpecialKey
highlight default link GlobalRef SpecialComment
highlight default link GlobalCite SpecialComment
highlight default link ClassTag Identifier

highlight default link VarField SpecialComment
highlight default link VarPath SpecialComment
highlight default link VarTag Label
highlight default link VarValue Tag

highlight default link PathField Warning
highlight default link PathName SpecialComment

highlight default link BlockText Normal
highlight default link BlockPunct Pmenu
highlight default link BlockLinePunct Ignore

highlight default link FieldLine Comment

highlight default link Bq Comment

highlight default link EntityName FoldColumn
highlight default link Dot SpecialComment

highlight default link ArgVar SpecialComment
highlight default link ArgOptional SpecialComment
highlight default link CmdLineSym Character

highlight default link MetaField Character
highlight default link MetaTag Directory
highlight default link MetaValue String
highlight default link MetaTagComment SpecialComment

highlight default link PlainBUG CursorLineNr
highlight default link PlainFIXME StatusLine
highlight default link PlainNOTE CursorLine
highlight default link PlainTODO Normal
highlight default link PlainXXX StatusLineNC


"highlight default link MetaTag Type
" XXX: Add our own link groups?


let b:current_syntax = "lest-txt"
