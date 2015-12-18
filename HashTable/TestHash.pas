program testHash;

uses HTable;

var testArray: Array[0..30000] of integer;
    i:integer;

//Create simple hash which just modulos with capacity for
//testing
function testHashFunc(keyPtr:pointer; capacity:longint):longint;
    begin
        result := intPtr(keyPtr)^ mod capacity;
    end;

function checkAdding(testArray:Array of integer):boolean;
   var hTable:THashTablePtr;
       i:integer;
   begin
        hTable := createHash(testHashFunc, IntegerCompare, 11);

        for i := 0 to 10000 do begin
            InsertHash(hTable,@testArray[i], @testArray[i]);
        end;
        writeln(hTable^.size);

   end;

Begin
 for i:= 0 to 30000 do
     testArray[i] := i;

 checkAdding(testArray);
 readln;


End.
