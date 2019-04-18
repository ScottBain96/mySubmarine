package submarine with SPARK_Mode
is
   --Setting current oxygenlevel and the minimum



   --Submarine types, operating or not operating and current state in water
   type SubmarineOperation is (IsOperating, NotOperating);
   type SubmarineStatus is (Submerged, Surfaced);



   --Record of submarine, made up of the operating state and status
   type Submarine is record
      operating : SubmarineOperation;
      statusInWater : SubmarineStatus;


        end record;
   --Initial submarine conditions, not operating and surfaced.
   NuclearSubmarine : Submarine := (operating => NotOperating, statusInWater => Surfaced);

   --DOORS


   --type locked or unlucked, must be one of these.

   type LockedUnlocked is (Locked, Unlocked);

   --type of status of door.

   type OpenClosed is (Open, Closed);

   -- defining fields of record.
   type Door is record
        lock : LockedUnlocked;
      status : OpenClosed;
   end record;

   --Objects Door1 & Door2 of type Door, initial state of opened and unlocked
   Door1 : Door := (lock => Unlocked, status => Open);
   Door2 : Door := (lock => Unlocked, status => Open);

    --Invariant for the airlock to be passed as a post condition on door procedures, ensures one is closed
   function airlocks return Boolean is
      (Door1.status = Closed or Door2.status = Closed);

      --Procedure lockDoor which checks that the status of the door is closed before it can be locked
   procedure lockDoor1 with
     Global => (In_Out => Door1),
     Pre => Door1.status = Closed,
     Post => Door1.status = Closed and Door1.lock = Locked;
   procedure lockDoor2 with
     Global => (In_Out => Door2),
     Pre => Door2.status = Closed,
     Post => Door2.status = Closed and Door2.lock = Locked;

   --Procedures to open both airlock doors, checks that the other is closed
   procedure openDoor2 with
     Global => (In_Out => (Door1, Door2)),
     Pre => Door1.status = Closed and Door2.lock = Unlocked,
     Post => airlocks;
   procedure openDoor1 with
     Global => (In_Out => (Door1, Door2)),
     Pre => Door2.status = Closed and Door1.lock = Unlocked,
     Post => airlocks;

   --Invariant to check BOTH doors in the airlock are locked
   function checkAirlockDoors return Boolean is
     (Door1.lock = Locked and Door2.lock = Locked);


     procedure beginOperating with
     Global => (In_Out => NuclearSubmarine, Input => (Door1, Door2)),
     Pre => checkAirlockDoors,
     Post => NuclearSubmarine.operating = IsOperating and checkAirlockDoors;



   --SUBMARINE OXYGEN, GIVING VALUES JUST AS AN EXAMPLE

   type submarineOxygen is range 0..100;
   oxygenLevel : submarineOxygen :=20;
   minOxygenLevel: submarineOxygen :=10;
   emptyOxygen : submarineOxygen := 0;

   --REACTOR HEAT,  GIVING VALUES JUST AS AN EXAMPLE

   type submarineHeat is range 0..100;
   reactorTemp : submarineHeat :=20;
   reactorMaxTemp : submarineHeat := 100;

   type submarineDepth is range 0..100;
   currentDepth : submarineDepth;
   maxDepth : submarineDepth;

   function checkReactor return Boolean is
      (reactorTemp >= reactorMaxTemp);

   function checkOxygen return Boolean is
     (oxygenLevel <= minOxygenLevel);

   function oxygenRunsOut return Boolean is
     (oxygenLevel <= emptyOxygen);

    function checkDepth return Boolean is
     (currentDepth >= maxDepth);

   --Display a warning if oxygen level is lower or equal to the minimum level
   --Using Invariant function (checkOxygen), also requires warning to be false;
   procedure displayWarning (warningMessage : in out Boolean)
     with
     Global => (Input => (oxygenLevel, minOxygenLevel)),
     Pre => checkOxygen and then warningMessage = False,
     Post => checkOxygen and then warningMessage = True;

   --if oxygen runs out, surface:

   procedure oxygenSurface (surface : in out Boolean)
     with
       Global => (Input => (oxygenLevel, emptyOxygen, reactorMaxTemp, reactorTemp)),
       Pre => (oxygenRunsOut or checkReactor) and then surface = False,
       Post=> (oxygenRunsOut or checkReactor) and then surface = True;

   --Check the depth
    procedure stopDepth (stopSubDepth : in out Boolean)
     with
       Global => (Input => (currentDepth, maxDepth)),
       Pre => checkDepth and then stopSubDepth = False,
       Post => checkDepth and then stopSubDepth = True;



   --Torpedos

   type Box is (loaded, unloaded, stored);
   type PH_Index is range 0..1;

   type torpedos is array (PH_Index) of Box;


   procedure fireTorpedo (d: in out torpedos; fired : in out Boolean ) with
    Pre => fired = True and then (for all J in d'Range => d(J) = loaded),
    Post => (for all J in d'Range => d(J) /= loaded) and then fired = False;

   procedure loadTorpedo (load : in out Boolean; d: in out torpedos) with
   Pre => load = True and then (for all J in d'Range => d(J) = stored),
   Post => (for all J in d'Range => d(J) = loaded) and then load = False;

   procedure storeTorpedo (store : in out Boolean; d: in out torpedos) with
   Pre => store = true and (for all J in d'Range => d(J) = unloaded),
   Post => (for all J in d'Range => d(J) = stored) and then store = False;


end submarine;
