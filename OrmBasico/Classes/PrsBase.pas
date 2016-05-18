{******************************************************************************}
{ Projeto: ORM - B�sico do Blog do Luiz                                        }
{ Este projeto busca agilizar o processo de manipula��o de dados (DAO/CRUD),   }
{ ou seja,  gerar inserts, updates, deletes nas tabelas de forma autom�tica,   }
{ sem a necessidade de criarmos classes DAOs para cada tabela. Tamb�m visa     }
{ facilitar a transi��o de uma suite de componentes de acesso a dados para     }
{ outra.                                                                       }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Luiz Carlos Alves                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{    Luiz Carlos Alves - contato@luizsistemas.com.br                           }
{                                                                              }
{ Voc� pode obter a �ltima vers�o desse arquivo no reposit�rio                 }
{ https://github.com/luizsistemas/ORM-Basico-Delphi                            }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{ Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{ Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Luiz Carlos Alves - contato@luizsistemas.com.br -  www.luizsistemas.com.br   }
{                                                                              }
{******************************************************************************}
unit PrsBase;

interface

uses DB, SysUtils, Classes, Rtti, System.TypInfo,
  System.Generics.Collections;

type
  TCamposArray = array of string;
  TFlagCampos = (fcAdd, fcIgnore);

  TTabela = class
  end;

  TConexaoBase = class
  private
    FSenha: string;
    FPorta: string;
    FUsuario: string;
    FLocalBD: string;
    FProtocolo: integer;
    FServer: string;
    procedure SetPorta(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetUsuario(const Value: string);
    procedure SetLocalBD(const Value: string);
    procedure SetTipo(const Value: integer);
    procedure SetServer(const Value: string);
  public
    function Conectado: Boolean; virtual; abstract;
    procedure Conecta; virtual; abstract;

    property LocalBD: string read FLocalBD write SetLocalBD;
    property Usuario: string read FUsuario write SetUsuario;
    property Senha: string read FSenha write SetSenha;
    property Porta: string read FPorta write SetPorta;
    property Protocolo: integer read FProtocolo write SetTipo; //0 - local 1 - tcpIP
    property Server: string read FServer write SetServer;
  end;

  IBaseSql = interface
    ['{3890762A-9CF2-46C3-A75C-62947D3DAD7B}']

    // gera��o do sql padrao
    function GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlDelete(ATabela: TTabela): string;

    function GerarSqlSelect(ATabela: TTabela): string; overload;

    function GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
       overload;

    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string;
      ACamposWhere: array of string): string; overload;
  end;

  TPadraoSql = class(TInterfacedObject, IBaseSql)
  public
    function GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlUpdate(ATabela: TTabela; TipoRtti: TRttiType;
      ACampos: array of string; AFlag: TFlagCampos = fcAdd): string;

    function GerarSqlDelete(ATabela: TTabela): string; virtual;

    function GerarSqlSelect(ATabela: TTabela): string; overload;

    function GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
       overload;

    function GerarSqlSelect(ATabela: TTabela; ACampos: array of string;
      ACamposWhere: array of string): string; overload;
  end;

  IQueryParams = interface
  ['{FBE0114E-931B-44FB-8325-45A68D2DE4E3}']
  // configura par�mentro para cada tipo de dado
    procedure SetParamInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetParamVariant(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);

  // m�todos para setar os variados tipos de campos
    procedure SetCamposInteger(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposString(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposDate(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
    procedure SetCamposCurrency(AProp: TRttiProperty; ACampo: string; ATabela: TTabela; AQry: TObject);
  end;

  IDaoBase = interface
  ['{6E2AFB66-465B-4924-9221-88E283E81EA7}']
  // configura e executa a query
    function ExecutaQuery: Integer;

  // pega campo autoincremento
    function GetID(ATabela:TTabela; ACampo: string): Integer;

  // comandos crud
    function Inserir(ATabela: TTabela): Integer; overload;
    function Inserir(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcIgnore): Integer; overload;

    function Salvar(ATabela: TTabela): Integer; overload;
    function Salvar(ATabela: TTabela; ACampos: array of string;
      AFlag: TFlagCampos = fcAdd): Integer; overload;

    function Excluir(ATabela: TTabela): Integer; overload;
    function Excluir(ATabela: TTabela; AWhere: array of string): Integer; overload;
    function Excluir(ATabela: string; AWhereValue: string): Integer; overload;
    function ExcluirTodos(ATabela: TTabela): Integer; overload;

    function Buscar(ATabela: TTabela): Integer;

    // dataset para as consultas
    function ConsultaAll(ATabela: TTabela): TDataSet;

    function ConsultaSql(ASql: string): TDataSet; overload;
    function ConsultaSql(ASql: string; const ParamList: Array of Variant): TDataSet; overload;
    function ConsultaSql(ATabela: string; AWhere: string): TDataSet; overload;

    function ConsultaTab(ATabela: TTabela; ACamposWhere: array of string)
      : TDataSet; overload;

    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere: array of string)
      : TDataSet; overload;

    function ConsultaTab(ATabela: TTabela; ACampos, ACamposWhere, AOrdem: array of string;
      TipoOrdem: Integer = 0): TDataSet; overload;

  // limpar campos da tabela
    procedure Limpar(ATabela: TTabela);

  // comandos transa��o
    procedure StartTransaction;
    procedure Commit;
    procedure RollBack;
    function  InTransaction: Boolean;
  end;

implementation

uses PrsAtributos;

{ TConexaoBase }

procedure TConexaoBase.SetLocalBD(const Value: string);
begin
  FLocalBD := Value;
end;

procedure TConexaoBase.SetPorta(const Value: string);
begin
  FPorta := Value;
end;

procedure TConexaoBase.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TConexaoBase.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TConexaoBase.SetTipo(const Value: integer);
begin
  FProtocolo := Value;
end;

procedure TConexaoBase.SetUsuario(const Value: string);
begin
  FUsuario := Value;
end;

{ PadraoSql}
function TPadraoSql.GerarSqlDelete(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Delete from ' + Atributos.PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlInsert(ATabela: TTabela; TipoRtti: TRttiType;
  ACampos: array of string; AFlag: TFlagCampos): string;
var
  Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Insert into ' + Atributos.PegaNomeTab(ATabela));
      Add('(');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + PropRtti.Name);
        Separador := ',';
      end;
      Add(')');

      // par�metros
      Add('Values (');
      Separador := '';

      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + ':' + PropRtti.Name);
        Separador := ',';
      end;
      Add(')');
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select * from ' + Atributos.PegaNomeTab(ATabela));
      Add('Where');
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela; ACamposWhere: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select * from ' + TAtributos.Get.PegaNomeTab(ATabela));
      Add('Where 1=1');
      Separador := ' and ';
      for Campo in ACamposWhere do
        Add(Separador + Campo + '= :' + Campo);
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlSelect(ATabela: TTabela; ACampos,
  ACamposWhere: array of string): string;
var
  Campo, Separador: string;
  ASql: TStringList;
begin
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Select ');

      if Length(ACampos)>0 then
      begin
        Separador := '';
        for Campo in ACampos do
        begin
          Add(Separador + Campo);
          Separador := ',';
        end;
      end
      else
        Add('*');

      Add(' from ' + TAtributos.Get.PegaNomeTab(ATabela));

      Add('Where 1=1');

      Separador := ' and ';

      for Campo in ACamposWhere do
        Add(Separador + Campo + '= :' + Campo);
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

function TPadraoSql.GerarSqlUpdate(ATabela: TTabela;
  TipoRtti: TRttiType; ACampos: array of string; AFlag: TFlagCampos): string;
var
  Campo, Separador: string;
  ASql: TStringList;
  PropRtti: TRttiProperty;
  Atributos: IAtributos;
begin
  Atributos := TAtributos.Create;
  ASql := TStringList.Create;
  try
    with ASql do
    begin
      Add('Update ' + Atributos.PegaNomeTab(ATabela));
      Add('set');

      // campos da tabela
      Separador := '';
      for PropRtti in TipoRtti.GetProperties do
      begin
        if Length(ACampos) > 0 then
          if ((AFlag = fcIgnore) and (Atributos.LocalizaCampo(PropRtti.Name, ACampos))) or
            ((AFlag = fcAdd) and (not Atributos.LocalizaCampo(PropRtti.Name, ACampos))) then
            continue;

        Add(Separador + PropRtti.Name + '=:' + PropRtti.Name);
        Separador := ',';
      end;
      Add('where');

      // par�metros da cl�usula where
      Separador := '';
      for Campo in Atributos.PegaPks(ATabela) do
      begin
        Add(Separador + Campo + '= :' + Campo);
        Separador := ' and ';
      end;
    end;
    Result := ASql.Text;
  finally
    ASql.Free;
  end;
end;

end.
