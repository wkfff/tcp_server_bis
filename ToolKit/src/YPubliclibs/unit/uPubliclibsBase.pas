unit uPubliclibsBase;

interface

uses
  Classes,
  Controls;

type
  IDragOnRunTime = interface
    ['{AD7A4374-66C0-41F1-BC27-16D83028732C}']
    function GetSelectControl: TControl;
    procedure SetSelectControl(const Value: TControl);
    property SelectControl: TControl read GetSelectControl write SetSelectControl;
  end;

implementation

end.
