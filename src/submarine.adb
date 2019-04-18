
package body submarine with SPARK_Mode
is


   procedure lockDoor1 is
   begin
      Door1.status := Closed;
      Door1.lock := Locked;
   end lockDoor1;

   procedure lockDoor2 is
   begin
      Door2.status := Closed;
      Door2.lock := Locked;
   end lockDoor2;

   procedure openDoor2 is
   begin
      Door1.status := Closed;
      Door2.status := Open;
   end openDoor2;

   procedure openDoor1 is
   begin
      Door2.status := Closed;
      Door1.status := Open;
   end openDoor1;

     procedure beginOperating is
   begin
      NuclearSubmarine.operating := IsOperating;
   end beginOperating;

   procedure displayWarning (warningMessage : in out Boolean) is
   begin
      warningMessage := True;
   end displayWarning;

   procedure oxygenSurface (surface : in out Boolean) is
   begin
      surface := True;
   end oxygenSurface;

    procedure stopDepth (stopSubDepth : in out Boolean) is
   begin
      stopSubDepth := True;
   end stopDepth;


   --TORPEDOS


   procedure fireTorpedo (d: in out torpedos; fired : in out Boolean) is
      Pos : PH_Index := d'First;
   begin
      if (fired = True) then
      while Pos < d'Last loop
         d(Pos) := unloaded;
          Pos := Pos + 1;
         end loop;
         d(d'Last) := unloaded;
      end if;
      fired := False;
   end fireTorpedo;


   procedure loadTorpedo (load : in out Boolean; d: in out torpedos) is
      a : PH_Index := d'First;
      b : PH_Index := d'Last;

   begin
      if (load = True) then
         for I in a..b loop
            d(I) := loaded;
         end loop;
      end if;
      load := False;
   end loadTorpedo;


   procedure storeTorpedo (store : in out Boolean; d: in out torpedos) is

      a : PH_Index := d'First;
      b : PH_Index := d'Last;


   begin

      if (store = True) then
         for I in a..b loop
            d(I) := stored;
         end loop;
      end if;
      store := False;
   end storeTorpedo;

end submarine;
