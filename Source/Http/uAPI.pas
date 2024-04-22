unit uAPI;

interface

uses
  System.Classes, IdHTTP, IdSSLOpenSSL, System.SysUtils, Rest.Json, System.JSON,
  Vcl.StdCtrls, IdMultiPartFormData, System.IniFiles, Vcl.Forms, Winapi.MMSystem,
  Winapi.Windows, Winapi.Messages, Vcl.Dialogs, IdGlobal;

  function HTTPCall(pQuery: string; reqBody: string): string;
  function SendIM: Boolean;

var
  tmp: string;

implementation

uses
  uGlobal;


function HTTPCall(pQuery: string; reqBody: string): string;
var
  HTTP: TIdHTTP;
  Buffer: string;
  pStr: string;
  reqStream, resStream: TStringStream;
  IdIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := '';

  try
    try
      HTTP := TIdHTTP.Create;

      IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create;
      IdIOHandler.SSLOptions.Method := sslvSSLv23;
      IdIOHandler.SSLOptions.Mode := sslmUnassigned;
      IdIOHandler.SSLOptions.SSLVersions := [sslvTLSv1,sslvTLSv1_1,sslvTLSv1_2];
      HTTP.IOHandler := IdIOHandler;

      try
        HTTP.Request.Clear;
        HTTP.Request.Accept      := '*/*';
        HTTP.Request.ContentType := 'application/json';
        HTTP.Response.KeepAlive := False;
//        HTTP.Request.ContentType := 'text/plain';
//        HTTP.Request.CustomHeaders.Add(AuthorizeKey); //로그인AccessToken key 보내기
        Log('HTTPCall : HTTP.Post - '+ pQuery + ' / ' +  reqBody);
        reqStream := TStringStream.Create(reqBody, TEncoding.UTF8);
        resStream := TStringStream.Create;
        resStream.Clear;

        HTTP.Post(pQuery, reqStream, resStream);
        resStream.SetSize(resStream.Size);
        Result := TEncoding.UTF8.GetString(resStream.Bytes);
        Log('HTTPCall Response : HTTP.Post - '+ Result);
      except
        on e: Exception do
        begin
          Log('HTTPCall : HTTP.Post - '+ e.Message);
//          Exit;
        end;
      end;
    finally
      if Assigned(resStream) then FreeAndNil(resStream);
      if Assigned(reqStream) then FreeAndNil(reqStream);

      HTTP.Destroy;
    end;
  except
    on E: Exception do
      Log('HTTPCall Exception : ' + E.Message);
  end;
end;

function SendIM: Boolean;
const
  _URL = 'http://10.22.37.101:4098/nxlprs/v1.0/bars/enter';
var
  HTTP     : TIdHTTP;
  Params   : TMemoryStream;
  Response : string;
  LMsg     : string;
begin
  Result := False;
  Params := TMemoryStream.Create;
  try
    with TStreamWriter.Create(Params, TEncoding.UTF8) do
    try
      NewLine := EOL;
      WriteLine('-----------------------------13932');
      WriteLine('Content-Type: application/json; charset=utf-8');
      WriteLine('Content-Description: message');
      WriteLine;
      WriteLine('{"cmd":"ENTER"}');
      WriteLine('-----------------------------13932--');
    finally
      Free;
    end;
    Params.Position := 0;

    HTTP := TIdHTTP.Create(nil);

    try

      HTTP.Request.UserAgent      := 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.104 Safari/537.36';
      HTTP.Request.Accept         := '*/*';
      HTTP.Request.Host           := '10.22.37.101:4098';
      HTTP.Request.ContentType    := 'multipart/mixed; boundary="---------------------------13932"';

      try
        Response := HTTP.Post(_URL, Params);
        Result := True;
      except
        on E: Exception do
          Writeln('Error on Send Message request: '#13#10, e.Message);
      end;
      Writeln(HTTP.Request.RawHeaders.Text);
    finally
      HTTP.Destroy;
    end;
  finally
    Params.Free;
  end;
end;



end.
