#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} WSRESTFUL

/*/
//-------------------------------------------------------------------------------------------------------------
WSRESTFUL WSMONITOR DESCRIPTION "Monitor de Servidores" //FORMAT APPLICATION_JSON

    WSDATA ip          AS STRING
    WSDATA port        AS STRING
    WSDATA environment AS STRING
    WSDATA obs         AS STRING
    WSDATA tabela      AS STRING
    WSDATA listUsers   AS LOGICAL

    WSMETHOD GET ALLSERVERS       DESCRIPTION "Retorna todos os servidores cadastrados." ;
        WSSYNTAX "/api/monitor/v1/allservers";
        PATH "/api/monitor/v1/allservers"

    WSMETHOD GET LISTSERVERS       DESCRIPTION "Lista os servidores para manuten��o." ;
        WSSYNTAX "/api/monitor/v1/listservers";
        PATH "/api/monitor/v1/listservers"

    WSMETHOD GET LISTINI           DESCRIPTION "Retorna todos os servidores cadastrados." ;
        WSSYNTAX "/api/monitor/v1/listini";
        PATH "/api/monitor/v1/listini"

    WSMETHOD POST CREATENEWSERVER  DESCRIPTION "Cria um servidor novo" ;
        WSSYNTAX "/api/monitor/v1/createnewserver";
        PATH "/api/monitor/v1/createnewserver"

    WSMETHOD POST DELETESERVER     DESCRIPTION "Deleta um servidor";
        WSSYNTAX "/api/monitor/v1/deleteserver";
        PATH "/api/monitor/v1/deleteserver"

END WSRESTFUL

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Metodo GET
Retorna todos os servidores cadastrados.

@author Jos� Mauro Dourado Lopes
@since 18/04/2020
@version 1.0
/*/
//---------------------------------------------------------------------------------------------------------------
WSMETHOD GET ALLSERVERS QUERYPARAM tabela WSREST WSMONITOR

Local cQuery    as character
Local cTabela   as character
Local nLogins   as numeric
Local nPos      as numeric
Local nX        as numeric
Local oServers  as object
Local oSrv      as object
Local aServers  as array
Local aLogins   as array
Local aTmp      as array

self:SetContentType("application/json")

nPos      := 1
nLogins   := 1
aServers  := {}
aLogins   := {}
oSrv      := NIL
cTabela   := self:tabela
cQuery    := U_RETSERVERS(cTabela)

(cQuery)->(dbGoTop())

while (cQuery)->(!Eof())
    Aadd(aServers,JsonObject():new())
    nPos := Len(aServers)

    aServers[nPos]['id']            := Alltrim((cQuery)->ID)
    aServers[nPos]['ip']            := Alltrim((cQuery)->IP)
    aServers[nPos]['port']          := Alltrim((cQuery)->PORT)
    aServers[nPos]['environment']   := Alltrim((cQuery)->ENVIRONMENT)
    aServers[nPos]['obs']           := Alltrim((cQuery)->OBS)
    aServers[nPos]['users']         := Alltrim((cQuery)->USERS)
    aServers[nPos]['delete']        := "delete"

    oSrv := RPCCONNECT( Alltrim((cQuery)->IP), VAL((cQuery)->PORT), Alltrim((cQuery)->ENVIRONMENT), 'T1', 'D MG 01' )
    if valtype(oSrv) == "O"
        If Alltrim((cQuery)->USERS) == 'T'
            oSrv:CALLPROC("RPCSetType", 3)
            aTmp  := oSrv:CALLPROC("GetUserInfoArray")
            For nX:=1 To Len(aTmp)
                Aadd(aLogins,JsonObject():new())
                nLogins := Len(aLogins)

                aLogins[nLogins]['idThread']       :=  aTmp[nX][3]
                aLogins[nLogins]['login']          :=  aTmp[nX][1]
                aLogins[nLogins]['computerName']   :=  aTmp[nX][2]
                aLogins[nLogins]['connectionHour'] :=  aTmp[nX][7]
                aLogins[nLogins]['time']           :=  aTmp[nX][8]
                aLogins[nLogins]['function']       :=  aTmp[nX][5]
                aLogins[nLogins]['typeThread']     :=  iif(Len(aTmp[nX])>=15,aTmp[nX][15],".")
                aLogins[nLogins]['observation']    :=  aTmp[nX][11]
            Next nX
            aServers[nPos]['listOfUsers']     := aLogins
            aServers[nPos]['numberOfUsers']   := Len(aTmp)

        EndIf
        aTmp := nil
        aServers[nPos]['inactive']        := "false"
        aServers[nPos]['memory']          := oSrv:CallProc("U_RETMEMORY")
        aServers[nPos]['processor']       := oSrv:CallProc("U_RETPROC")
        oSrv:CALLPROC("RpcClearEnv")
        RPCDISCONNECT(oSrv)
    else
        aServers[nPos]['inactive']        := "true"
    endif
    (cQuery)->(DbSkip())
enddo

RpcClearEnv()
RpcSetType(3)
RpcSetEnv( 'T1', 'D MG 01' )
If Empty(__cUSerID)
    cUserName  := 'Administrador'
    __cUSerID  := '000000'
Endif

oServers := JsonObject():New()
oServers['items'] := aServers

::SetContentType("application/json")
::SetStatus(200)
::SetResponse(oServers:toJSON())

Return .T.

//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Metodo GET
Retorna todos os servidores cadastrados.

@author Jos� Mauro Dourado Lopes
@since 18/04/2020
@version 1.0
/*/
//---------------------------------------------------------------------------------------------------------------
WSMETHOD GET LISTSERVERS QUERYPARAM tabela WSREST WSMONITOR

Local cQuery    as character
Local cBody     as character
Local cTabela   as character
Local nPos      as numeric
Local oServers  as object
Local oJson     as object
Local aServers  as array


cBody           := ''
oJson           := JsonObject():New()
cBody           := self:GetContent()
self:SetContentType("application/json")

cTabela   := self:tabela
nPos      := 1
aServers  := {}
cQuery    := U_RETSERVERS(cTabela)

(cQuery)->(dbGoTop())

while (cQuery)->(!Eof())
    Aadd(aServers,JsonObject():new())
    nPos := Len(aServers)

    aServers[nPos]['id']            := Alltrim((cQuery)->ID)
    aServers[nPos]['ip']            := Alltrim((cQuery)->IP)
    aServers[nPos]['port']          := Alltrim((cQuery)->PORT)
    aServers[nPos]['environment']   := Alltrim((cQuery)->ENVIRONMENT)
    aServers[nPos]['obs']           := Alltrim((cQuery)->OBS)
    aServers[nPos]['users']         := Alltrim((cQuery)->USERS)
    aServers[nPos]['delete']        := "delete"

    (cQuery)->(DbSkip())
enddo

oServers := JsonObject():New()
oServers['items'] := aServers

::SetContentType("application/json")
::SetStatus(200)
::SetResponse(oServers:toJSON())

Return .T.

WSMETHOD POST DELETESERVER WSREST WSMONITOR

Local cBody         as character
Local nX            as numeric
Local nSize         as numeric
Local oJson         as object

cBody           := ''
oJson           := JsonObject():New()
cBody           := self:GetContent()

oJson:fromJSON( cBody )

DBSelectArea("ZZZ")
ZZZ->(DBSetOrder( 1 ))
nSize := len(oJson["idsServers"])

For nX := 1 to nSize
    If ZZZ->(DBSeek(xFilial("ZZZ") + oJson["idsServers"][nX]))
        RecLock("ZZZ", .F.)
        DBDelete()
        ZZZ->(MsUnlock())
    EndIf
Next nX

ZZZ->( DbCloseArea() )

oNotifications := JsonObject():New()
oNotifications['retorno'] := "Sucesso"

::SetContentType("application/json")
::SetStatus(200)
::SetResponse(oNotifications:toJSON())

Return .T.

WSMETHOD GET LISTINI WSREST WSMONITOR

Local aIniSession := Nil
Local nI := 0
Local aLen := 0

aIniSession := GetIniSessions("TOTVSAPPSERVER.INI")
aLen = Len(aIniSession)
conout(" Total Sessions: " + cValToChar(aLen))

If aLen > 0
    For nI := 1 to aLen
        conout(aIniSession[nI])
    Next nI
EndIf
Return
//-------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} Metodo POST
@params
@author Jos� Mauro Dourado Lopes
@since 01/04/2020
@version 1.0
/*/
//---------------------------------------------------------------------------------------------------------------
WSMETHOD POST CREATENEWSERVER  WSREST WSMONITOR

Local cBody         as character
Local nPos          as numeric
Local oServers      as object
Local oJson         as object
Local aServers      as array
Local aRetCampos    as array

cBody       := ''
oJson       := JsonObject():New()
cBody       := self:GetContent()
aRetCampos  := {}
aServers    := {}

oJson:fromJSON( cBody )

cMessage := U_JSONVALID( oJson )

Aadd(aServers,JsonObject():new())
nPos := Len(aServers)

If !Empty(cMessage)
    aServers[nPos]['mensagem']    := cMessage
else
    Aadd(aServers,JsonObject():new())
    IF U_WSSERVER(oJson["ip"],oJson["port"],oJson["environment"],oJson["listUsers"],oJson["obs"])
        aServers[nPos]['mensagem']    := "Servidor criado com sucesso."
    EndIF
Endif

oServers := JsonObject():New()
oServers['items'] := aServers

::SetContentType("application/json")
::SetStatus(200)
::SetResponse(oServers:toJSON())

Return .T.
/*/{Protheus.doc} User Function WSSERVER
    (long_description)
    @type  Function
    @author user
    @since 22/05/2020
    @version version
    @param 
        cIp     -> IP do Servidor a ser cadastrado.
        cPorta  -> Porta do Servidor a ser cadastrado.
        cEnviro -> Ambiente do Servidor a ser cadastrado.
        cUsers  -> Booleano para saber se lista ou n�o os usu�rios conectados no servidor.
        cObs    -> Observa��o do servidor a ser cadastrado.
    @return 
        lRet -> Retorna lRet se o cadastro foi realizado com sucesso ou n�o.
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function WSSERVER(cIp,cPorta,cEnviro,cUsers,cObs)

    Local lRet 		 as logical
    Local oModelZZZ  as object

    Local oMdlZZZ    := FWLoadModel("SERVER")
    Local cID        := TAFGERAID("TAF")

    lRet  := .F.
    oModelZZZ := oMdlZZZ:GetModel( "MODEL_ZZZ" )

    oMdlZZZ:SetOperation(3)
    oMdlZZZ:Activate()

    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_ID'  	 , cID      )
    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_IP'	 , cIp      )
    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_PORTA'	 , cPorta   )
    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_AMBIEN' , cEnviro  )
    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_USERS'  , .F.      )
    oMdlZZZ:LoadValue( 'MODEL_ZZZ', 'ZZZ_OBS'	 , cObs     )

    If oMdlZZZ:VldData()
        FwFormCommit(oMdlZZZ)
        lRet := .T.
        oMdlZZZ:Destroy()
        oMdlZZZ := Nil
    EndIf

Return lRet

/*/{Protheus.doc} User Function RETMEMORY
    @type  Function
    @author user
    @since 22/05/2020
    @version version
    @param 
    @return 
        nMemory -> Retorna o percentual de mem�ria utilizado.
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RETMEMORY()
    Local cInfo     as character
    Local aInfo     as array
    Local nMemory   as numeric

    cInfo := GETSRVMEMINFO()
    aInfo := StrTokArr( cInfo, "   " )
    nMemory := NOROUND((VAL(aInfo[7])/VAL(aInfo[4]))*100,2)
Return nMemory

/*/{Protheus.doc} User Function RETPROC
    @type  Function
    @author user
    @since 22/05/2020
    @version version
    @param 
    @return 
        nProcessa -> Retorna o n�mero de processadores da m�quina.
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RETPROC()
    Local aInfoComp as array
    Local nProcessa as numeric

    aInfoComp := GetSrvInfo()
    nProcessa := aInfoComp[5]

Return nProcessa

/*/{Protheus.doc} User Function RETSERVERS
    @type  Function
    @author user
    @since 22/05/2020
    @version version
    @param 
    @return 
        cAlias -> Retorna o alias dos servidores cadastrados.
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RETSERVERS(cTabela)

    Local cAlias    as character
    Local cSelect   as character
    Local cFrom     as character
    Local cWhere    as character

    cFrom  := RetSqlName( cTabela )
    cAlias := GetNextAlias()

    cSelect := cTabela+"_ID     AS ID,          "
    cSelect += cTabela+"_IP     AS IP,          "
    cSelect += cTabela+"_PORTA  AS PORT,        "
    cSelect += cTabela+"_AMBIEN AS ENVIRONMENT, "
    cSelect += cTabela+"_OBS    AS OBS,         "
    cSelect += cTabela+"_USERS  AS USERS        "

    cWhere  := " D_E_L_E_T_ = ' ' "

    cSelect	:= "%" + cSelect  + "%"
    cFrom  	:= "%" + cFrom    + "%"
    cWhere 	:= "%" + cWhere   + "%"

    BeginSql Alias cAlias
    	SELECT %Exp:cSelect% FROM %Exp:cFrom%  WHERE %EXP:cWhere%
    EndSql

Return cAlias


/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 22/05/2020
    @version version
    @param 
        oJson -> Recebe o objeto recido na requisi��o.
    @return 
        cMessage -> Retorna uma mensagem informando que algum campo obrigat�rio n�o foi informado.
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JSONVALID( oJson )
    Local cMessage	:= ""

    If Empty( oJson["ip"] ) .or. oJson["ip"] == nil
        cMessage := ENCODEUTF8("Campo IP � obrigat�rio")
    ElseIf Empty( oJson["port"] ) .or. oJson["port"] == nil
        cMessage := ENCODEUTF8("Campo porta � obrigat�rio")
    ElseIf Empty( oJson["environment"] ) .or. oJson["environment"] == nil
        cMessage := ENCODEUTF8("Campo ambiente obrigat�rio")
    ElseIf Empty(  oJson["listUsers"] ) .or.  oJson["listUsers"] == nil
        cMessage := ENCODEUTF8("Campo lista usu�rio � obrigat�rio")
    EndIf
Return cMessage