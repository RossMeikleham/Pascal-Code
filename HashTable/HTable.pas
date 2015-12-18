{ Simple Linear Probing HashTable implementation for VP
  Ross Meikleham 2014 }
unit HTable;

interface

const MAXLOAD=0.7; {Once table load exceeds this amount we rebuild the hash}
      MINLOAD=0.2; {If table goes under this load rebuild the hash}

      //Prime capacities of table as it increases in size roughly doubles//
      capacities: array [0..28] of longInt =
        (11, 23, 47, 97, 193, 389, 769, 1543, 3079, 6151, 12289, 24593,
         49157, 98317, 196613, 393241, 786433, 1572869, 3145739,
         6291469, 12582917, 25165843, 50331653, 100663319, 201326611,
         402653189, 805306457, 1610612741, 2147483647);

Type

    doublePtr = ^pointer; //Pointer to pointer nothing to do with double type
    intPtr = ^integer;  //Pointer to integer

    {Hash Function which takes a pointer and integer (should be positive)
     should ALWAYS return an integer less than capacity but greater
     than or equal to 0}
    THashFunc = function(keyPtr:pointer;capacity:longint):longint;

    {Function which takes 2 pointers and compares their
     specified dereferenced values, should return 0 if equal, -1 if a < b
     and 1 if a > b}
    TCompareFunc = function(a,b:pointer):integer;

    {VP lacks enum, so have to use 3 booleans to mark state of
     an element in the hash, either element has been deleted,
     an element has never been in the slot "empty", or it's
     occupied}
    TState = record
        deleted:boolean;
        empty:boolean;
        occupied:boolean;
    end;

    //Element contains key,value pairs and state//
    THashElement = record
        key:pointer;
        value:pointer;
        state:TState;
    end;

    THashElementPtr = ^THashElement;

    {Hash Table}
    THashTable = record
        elements:THashElementPtr; {Pointer to Element containing stored value}
        size:integer;       {Current amount of elements in table}
        capacity:integer;   {Total capacity of table}
        hash:THashFunc; {Supplied hash function to determine where to place elements}
        compare:TCompareFunc; {Supplied function to test equality of elements}
        stepSize:Integer;   {value to add to current index to check next}
    end;

    THashTablePtr = ^THashTable;

{ Exposed subroutines to use with hashes }
function CreateHash(hashFunc:THashFunc; compareFunc:TCompareFunc; size:longint) : THashTablePtr;
procedure DeleteHash(hTablePtr: THashTablePtr);

function InsertHash(var hTable:THashTablePtr; key, val:Pointer):boolean;
function GetHash(hTable:THashTablePtr; key:pointer):pointer;
function RemoveHash(hTable: THashTablePtr; key:pointer):pointer;

function IntegerCompare(a,b:pointer):integer;


implementation


//Evil hackery to add integers to pointers
function AddIntToPtr(ptr:pointer; val:integer):pointer;
   begin
        result :=  pointer(cardinal(ptr) + val*sizeof(THashElement));
   end;




//Example simple hash function for integer types
function IntegerHash(keyPtr:pointer;capacity:integer):integer;
    begin
        result :=  1;
    end;





//Example compare function for integer types
function IntegerCompare(a,b:pointer):integer;
    begin
        result := intPtr(a)^ - intPtr(b)^;
    end;





//Obtain the load factor 0-1 (size/capacity)
function getLoadFactor(var hTable:THashTable):real;

    begin
        result := (hTable.size * 1.0) / hTable.capacity;
    end;





{Gets the next highest capacity available from global list
 returns -1 if it can't go any higher }
function getNextCapacity(oldCapacity:longInt):longInt;
   var i:integer;
   begin
        i := 0;
        while (oldCapacity >= capacities[i]) and (i < 29) do
            inc(i);

        if (i > 28) then
            result := -1
        else
            result := capacities[i];

   end;




{Gets the next lowest capacity available from global list
 returns -1 if it can't go any lower }
function getPreviousCapacity(oldCapacity:longInt):longInt;
    var i:integer;
    begin
        i:=29;
        while (oldCapacity <= capacities[i]) and (i >-1) do
            dec(i);

        if (i > -1) then
            result := -1
        else
            result := capacities[i];
    end;




{Returns a pointer to a THashTable if successful,
 nil otherwise}
function CreateHash(hashFunc:THashFunc; compareFunc:TCompareFunc; size:longint) : THashTablePtr;

    var hTable:THashTablePtr;
        hashElementPtr:THashElementPtr;
        i:longInt;

    begin
        //Allocate space on heap for table
        hTable := nil;
        getMem(hTable, sizeof(THashTable));

        //If system can't allocate memory, then return nil
        if hTable = nil then begin
                result := nil;
                Exit;
        end;

        //Otherwise://

        //Initialize values//
        hTable^.size := 0;
        hTable^.capacity := size;
        hTable^.hash := hashFunc;
        hTable^.compare := compareFunc;

        //Allocate space on the heap for the elements//
        Getmem(hTable^.elements, sizeof(THashElement) * hTable.capacity);

        //Check if getmem was successful//
        if (hTable^.elements = nil) then begin
            //If not Need to free memory allocated to table else memory leaks ahoy//
            FreeMem(hTable, sizeof(THashTable));
            result := nil;
        end else begin
            //Initialize element defaults
            for i := 0 to hTable^.capacity-1 do begin

                hashElementPtr := AddIntToPtr(hTable^.elements, i);
                hashElementPtr^.state.empty := true;
                hashElementPtr^.state.occupied := false;
                hashElementPtr^.state.deleted := false;

            end;
            result := hTable;
        end;
    end;




//Swap the contents of two elements
procedure ElementSwap(var element1, element2: THashElement);
    var tempState:TState;
        tempKey, tempValue:pointer;
    begin
       tempState := element1.state;
       tempKey := element1.key;
       tempValue := element1.value;

       element1.state := element2.state;
       element1.key := element2.value;
       element1.value := element2.value;

       element2.state := tempState;
       element2.key := tempKey;
       element2.value := tempValue;
    end;




//Free all memory relating to the given hash
procedure deleteHash(hTablePtr: THashTablePtr);
    begin
        FreeMem(hTablePtr^.elements, hTablePtr^.size);
        FreeMem(hTablePtr);
    end;



{Attempts to increase the size of the hash, returns true if
 successful, false otherwise. uses naive method of
 generating larger hash copying then deleting the old
 could be improved with incremental adding}
function resizeHash(var hTable: THashTablePtr; size:longInt):Boolean;
    var i:longInt;
        b:boolean;
        newTable:THashTablePtr;
        element:THashElementPtr;
    begin

        if size < 0 then
            result := false
        else begin

            // Attempt to create larger hash//
            newTable := nil;
            newTable := createHash(hTable^.hash, hTable^.compare, size);
            if newTable = nil then begin
                result := false;
                Exit;
            end;

            //Copy all values from old to new
            for i := 0 to (hTable^.capacity-1) do begin

                element := THashElementPtr(AddIntToPtr(hTable^.elements, i));

                if (element^.state.occupied = true) then begin

                   //If we have problems copying values over delete the new hash and
                   //return false
                   if InsertHash(newTable, element.key, element.value) = false then begin

                        deleteHash(newTable);
                        result := false;
                        Exit;
                   end;
                end;
            end;
            //Delete old table
            deleteHash(hTable);
        end;
        hTable := newTable;
        result := true;

    end;



{Increase size of hash, returns true if successful,
 false otherwise}
function resizeHashLarger(var hTable:THashTablePtr):boolean;
     var newSize:longInt;
     begin
        newSize := getNextCapacity(hTable.capacity);

        if newSize < 0 then
            result := false
        else
            result:= resizeHash(hTable, newSize);
     end;




{Decrease size of hash, returns true if successful,
 false otherwise}
function resizeHashSmaller(var hTable:THashTablePtr):boolean;
    var newSize:longInt;
    begin
        newSize := getPreviousCapacity(hTable.capacity);
        if newSize < 0 then
            result := false
        else
            result := resizeHash(hTable, newSize);
    end;




{Attempts to insert a value into the hash, returns true if
 successful, false otherwise }
function InsertHash(var hTable:THashTablePtr; key, val:Pointer):boolean;

    var element:THashElementPtr;
        pos, initialPos:integer;
        found:boolean;

    begin

        //Increase the size of the hash if needed
        if getLoadFactor(hTable^) > MAXLOAD then
                if not resizeHashLarger(hTable) then begin
                    result := false;
                    exit;
                end;

        {Use the hash function to calculate where in the table
         the value should be placed}
        found := false;
        initialPos := hTable^.hash(key, hTable^.capacity);
        pos := initialPos;

        while found = false do begin
            {While the place we find is occupied, we linearly step over
            elements and if needed loop round the array to find an empty
            spot}
            element := THashElementPtr(AddIntToPtr(hTable^.elements,  pos));
            if not element^.state.occupied then
                found := true
            else begin
                pos := (pos+hTable^.stepSize) mod hTable^.capacity;

                if pos = initialPos then begin //we've gone in a circle something's wrong
                        result := false;
                        Exit;
                end;
            end;
        end;

        {Place key,value pair items in the element and set
         appropriate flags}
        element^.key := key;
        element^.value := val;
        element^.state.empty := false;
        element^.state.occupied := TRUE;
        element^.state.deleted := false;
        Inc(hTable^.size);
        result:= true;

    end;






{Looks for the element containing the specified key
 and removes it if it exists, returns the value removed
 otherwise returns nil if it didn't exist}
function removeHash(hTable: THashTablePtr; key:pointer):pointer;
 var pos,initialPos:integer;
        found:boolean;
        element:THashElementPtr;
    begin

        found := false;
        initialPos :=  hTable^.hash(key, hTable^.capacity);
        pos := initialPos;

        while not found do begin
            element := THashElementPtr(AddIntToPtr(hTable^.elements,pos));
            //Compare keys to see if we have found our value
            if hTable^.compare(key, element^.key) = 0 then
                found := true
            else begin
                {If we come across an empty that hasn't been occupied
                 then our element isn't present in the hash}
                if element^.state.empty = true then begin
                        result := nil;
                        Exit;
                end;

                pos := (pos+hTable^.stepSize) mod hTable^.capacity;

                //We've gone in a circle element isn't present
                if pos = initialPos then begin
                        result := nil;
                        Exit;
                end;

            end;
        end;
        //Mark for deletion
        element^.state.deleted := true;
        element^.state.empty := false;
        element^.state.occupied := false;
        result := element^.value;
        DEC(hTable^.size)
    end;







function GetHash(hTable:THashTablePtr; key:pointer):pointer;
    var pos,initialPos:integer;
        found:boolean;
        element, deleted:THashElementPtr;
    begin
        deleted := nil;
        found := false;
        initialPos :=  hTable^.hash(key, hTable^.capacity);
        pos := initialPos;

        while not found do begin
            element := THashElementPtr(AddIntToPtr(hTable^.elements,pos));
            //Compare keys to see if we have found our value
            if hTable^.compare(key, element^.key) = 0 then
                found := true
            else begin
                {If we come across an empty that hasn't been occupied
                 then our element isn't present in the hash}
                if element^.state.empty = true then begin
                        result := nil;
                        Exit;
                end;

                {Check if the cell has been deleted, if so
                 we can mark it to move the element we're looking
                 for into there for faster access next search
                 (provided it's in the table)}
                if (deleted = nil) and (element^.state.deleted = true) then
                        deleted := element;

                pos := (pos+hTable^.stepSize) mod hTable^.capacity;

                //We've gone in a circle element isn't present
                if pos = initialPos then begin
                        result := nil;
                        Exit;
                end;

            end;
        end;
        result := element^.value;
        //Found a better spot to place our element, let's move it there
        if deleted <> nil then
                ElementSwap(deleted^, element^);
    end;


end.
