unit RegisterPlugins;

interface

uses uPSComponent;

type
  TPSPluginClass = class of TPSPlugin;

procedure RegisterPSPlugins(PS: TPSScript);

implementation

uses uPSComponent_Default, uPSComponent_StdCtrls, uPSComponent_Controls,
     uPSComponent_Forms, uPSComponent_DB, uPSComponent_COM,

     uPSI_Dialogs, uPSI_SysUtils, uPSI_Utils;

procedure RegisterPlugin(PS: TPSScript; APluginClass: TPSPluginClass);
begin
  with TPSPluginItem(PS.Plugins.Add) do
  begin
    Plugin := APluginClass.Create(PS);
  end;
end;

procedure RegisterPSPlugins(PS: TPSScript);
begin
  //Pascal Script Plugins
  RegisterPlugin(PS, TPSImport_Classes);
  RegisterPlugin(PS, TPSImport_DateUtils);
  RegisterPlugin(PS, TPSImport_ComObj);
  RegisterPlugin(PS, TPSImport_DB);
  RegisterPlugin(PS, TPSImport_Controls);
  RegisterPlugin(PS, TPSImport_StdCtrls);
  RegisterPlugin(PS, TPSImport_Forms);
  RegisterPlugin(PS, TPSDllPlugin);

  //Extended Plugins
  RegisterPlugin(PS, TPSImport_Dialogs);
  RegisterPlugin(PS, TPSImport_SysUtils);
  RegisterPlugin(PS, TPSImport_Utils);
end;

end.
