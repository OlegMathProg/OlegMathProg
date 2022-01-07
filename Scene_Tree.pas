﻿unit Scene_Tree;

{This file contains some routines for scene object manager}

{$mode objfpc}{$H+}

interface

uses

  Classes, Fast_Primitives;

type

  TSceneTree   =class;

  TLayerType   =(ltStatic,ltDynamic);
  PLayerType   =^TLayerType;

  TKindOfObject=(kooEmpty,kooBkgnd,kooBkTex,kooRGrid,kooSGrid,kooGroup,kooTlMap,kooActor,kooPrtcl,kooCurve);
  PKindOfObject=^TKindOfObject;

  TPosShiftType=(pstAll,pstChildren);
  PPosShiftType=^TPosShiftType;

  TBkgndProp   =packed record {$region -fold}
    bckgd_obj_ind: TColor;
  end; {$endregion}
  PBkgndProp   =^TBkgndProp;

  TBkTexProp   =packed record {$region -fold}
    bktex_obj_ind: TColor;
  end; {$endregion}
  PBkTexProp   =^TBkTexProp;

  TRGridProp   =packed record {$region -fold}
    rgrid_obj_ind: TColor;
  end; {$endregion}
  PRGridProp   =^TRGridProp;

  TSGridProp   =packed record {$region -fold}
    sgrid_obj_ind: TColor;
  end; {$endregion}
  PSGridProp   =^TSGridProp;

  TGroupProp   =packed record {$region -fold}
    group_obj_ind: TColor;
    children_cnt : TColor;
  end; {$endregion}
  PGroupProp   =^TGroupProp;

  TTlMapProp   =packed record {$region -fold}
    tlmap_obj_ind: TColor;
  end; {$endregion}
  PTlMapProp   =^TTlMapProp;

  TActorProp   =packed record {$region -fold}
    actor_obj_ind: TColor;
  end; {$endregion}
  PActorProp   =^TActorProp;

  TPrtclProp   =packed record {$region -fold}
    prtcl_obj_ind: TColor;
  end; {$endregion}
  PPrtclProp   =^TPrtclProp;

  TObjInfo     =packed record {$region -fold}
    // background (bitmap destination) handle:
    bkgnd_ptr                : PInteger;
    // background (bitmap destination) width:
    bkgnd_width              : TColor;
    // background (bitmap destination) height:
    bkgnd_height             : TColor;
    // outter clipping rectangle:
    rct_clp                  : TPtRect;
    // (global) position of an object inside object array:
    g_ind                    : TColor;
    // (local) position of an object inside kind og oject:
    k_ind                    : TColor;
    // (global) position of an object inside scene tree:
    t_ind                    : TColor;
    // animation type of object:
    anim_type                : TLayerType;
    // kind of object: spline, actor,...etc.:
    koo                      : TKindOfObject;
    // is object visible:
    obj_show                 : boolean;
    // is object abstract(for example prefab/null/group) or drawable in scene:
    abstract                 : boolean;
    // does object allow to move itself:
    movable                  : boolean;
    // does object allow to scale itself:
    scalable                 : boolean;
    // does object allow to rotate itself:
    rotatable                : boolean;
    // is another  kind of object is available after current object:
    is_another_obj_kind_after: boolean;
    // is abstract kind of object is available after current object:
    is_an_abst_obj_kind_after: boolean;
    // local axis:
    local_axis               : TPtPos;
    // parallax:
    world_axis_shift         : TPtPos;
    parallax_shift           : TPtPos;
    // distance between world axis and local axis:
    obj_dist1                : TColor;
    // distance between camera and current object:
    obj_dist2                : TColor;
  end; {$endregion}
  PObjInfo     =^TObjInfo;

  TSceneTree   =class         {$region -fold}
    public
      global_prop   : TObjInfo;
      //
      obj_arr       : array of TObjInfo;
      //
      FilProc       : array of TProc0;
      //
      MovProc       : array of TProc0;
      // array of objects indices inside of object array:
      obj_inds_arr  : array of TColor;

      {array of indices inside of object array} {$region -fold}
      empty_inds_obj_arr: TColorArr;
      bkgnd_inds_obj_arr: TColorArr;
      bktex_inds_obj_arr: TColorArr;
      rgrid_inds_obj_arr: TColorArr;
      sgrid_inds_obj_arr: TColorArr;
      group_inds_obj_arr: TColorArr;
      tlmap_inds_obj_arr: TColorArr;
      actor_inds_obj_arr: TColorArr;
      prtcl_inds_obj_arr: TColorArr;
      curve_inds_obj_arr: TColorArr; {$endregion}

      {array of indices inside of scene tree--} {$region -fold}
      empty_inds_sct_arr: TColorArr;
      bkgnd_inds_sct_arr: TColorArr;
      bktex_inds_sct_arr: TColorArr;
      rgrid_inds_sct_arr: TColorArr;
      sgrid_inds_sct_arr: TColorArr;
      group_inds_sct_arr: TColorArr;
      tlmap_inds_sct_arr: TColorArr;
      actor_inds_sct_arr: TColorArr;
      prtcl_inds_sct_arr: TColorArr;
      curve_inds_sct_arr: TColorArr; {$endregion}

      {count of items-------------------------} {$region -fold}
      empty_cnt     : TColor;
      bkgnd_cnt     : TColor;
      bktex_cnt     : TColor;
      rgrid_cnt     : TColor;
      sgrid_cnt     : TColor;
      group_cnt     : TColor;
      tlmap_cnt     : TColor;
      actor_cnt     : TColor;
      prtcl_cnt     : TColor;
      curve_cnt     : TColor; {$endregion}

      // current object index:
      curr_obj_ind  : TColor;
      // count of all objects in scene:
      obj_cnt       : TColor;
      // low layer objects count:
      low_lr_obj_cnt: TColor;

      // count of selected objects of "Groups":
      group_selected: boolean;
      // count of selected objects of "Tile Map":
      tlmap_selected: boolean;
      // count of selected objects of "Actors":
      actor_selected: boolean;
      // count of selected objects of "Particles":
      prtcl_selected: boolean;
      // count of selected objects of "Splines"("Curves"):
      curve_selected: boolean;

      constructor Create;                                                                    {$ifdef Linux}[local];{$endif}
      destructor  Destroy;                                                         override; {$ifdef Linux}[local];{$endif}
      procedure FilEmpty;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilBkgnd;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilBkTex;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilRGrid;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilSGrid;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilGroup;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilTlMap;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilActor;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilPrtcl;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilCurve;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure MovCurve;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure FilScene;                                                            inline; {$ifdef Linux}[local];{$endif}
      procedure MovWorldAxisShiftRight;                                              inline; {$ifdef Linux}[local];{$endif}
      procedure MovWorldAxisShiftLeft;                                               inline; {$ifdef Linux}[local];{$endif}
      procedure MovWorldAxisShiftDown;                                               inline; {$ifdef Linux}[local];{$endif}
      procedure MovWorldAxisShiftUp;                                                 inline; {$ifdef Linux}[local];{$endif}
      procedure SetWorldAxisShift    (         world_axis_shift_:TPtPos);            inline; {$ifdef Linux}[local];{$endif}
      procedure SetParallaxShift     (         parallax_shift_  :TPtPos);            inline; {$ifdef Linux}[local];{$endif}
      procedure SetParallaxShift     (         parallax_shift_  :TColor);            inline; {$ifdef Linux}[local];{$endif}
      procedure SetFilProc           (         abstract_        :boolean;
                                               Proc0            :TProc0;
                                     var       obj_cnt_         :TColor;
                                     var       inds_obj_arr_,
                                               inds_sct_arr_    :TColorArr);         inline; {$ifdef Linux}[local];{$endif}
      procedure Add                  (constref koo              :TKindOfObject;
                                      constref world_axis_shift_:TPtPos);            inline; {$ifdef Linux}[local];{$endif}
      procedure SetObjBkgnd          (constref obj_arr_ptr      :PObjInfo;
                                      constref bkgnd_ptr        :PInteger;
                                      constref bkgnd_width,
                                               bkgnd_height     :TColor;
                                      constref rct_clp          :TPtRect);           inline; {$ifdef Linux}[local];{$endif}
      // (Checks If Another Kind Of Object Is Available After Selected Object(From start_ind) In Objects array(obj_arr)) Проверяет есть ли другой вид обьектов после выбранного(начиная с start_ind) в массиве обьектов(obj_arr):
      function  IsAnotherObjKindAfter(constref koo              :TKindOfObject;
                                      constref start_ind        :TColor=0): boolean; inline; {$ifdef Linux}[local];{$endif}
      function  IsNotAbstObjKindAfter(constref koo              :TKindOfObject;
                                      constref start_ind        :TColor=0): boolean; inline; {$ifdef Linux}[local];{$endif}
      function  IsNotAbstObjKindAfter(constref start_ind        :TColor=0): boolean; inline; {$ifdef Linux}[local];{$endif}
      // (Calculate Low Layer Objects Count) Подсчет количества обьектов нижнего слоя:
      function  LowLrObjCntCalc: TColor;                                             inline; {$ifdef Linux}[local];{$endif}
      // check equality of two objects by kind:
      function  AreTwoObjKindEqual   (constref obj_ind1,
                                               obj_ind2         :TColor): boolean;   inline; {$ifdef Linux}[local];{$endif}
      //
      function  Min9                 (constref obj_inds_arr_    :TColorArr;
                                      constref arr              :TEdgeArr;
                                      constref max_item_val     :TColor;
                                      constref item_cnt         :TColor): TColor;    inline; {$ifdef Linux}[local];{$endif}
      function  Min9                 (constref obj_inds_arr_    :TColorArr;
                                      constref arr              :TSlPtArr;
                                      constref max_item_val     :TColor;
                                      constref item_cnt         :TColor): TColor;    inline; {$ifdef Linux}[local];{$endif}
  end; {$endregion}
  PSceneTree   =^TSceneTree;

  TNodeData    =packed record {$region -fold}
    g_ind: TColor;
    {case TKindOfObject of
      kooBckgd: (bckgd_prop: TBckgdProp);
      kooBkTex: (bktex_prop: TBkTexProp);
      kooRGrid: (rgrid_prop: TRGridProp);
      kooSGrid: (sgrid_prop: TSGridProp);
      kooGroup: (group_prop: TGroupProp);
      kooTlMap: (tlmap_prop: TTlMapProp);
      kooActor: (actor_prop: TActorProp);
      kooPrtcl: (prtcl_prop: TPrtclProp);
      kooCurve: (curve_prop: TCurveProp);}
  end; {$endregion}
  PNodeData    =^TNodeData;

var

  {Object Properties}
  bkgnd_prop: TBkgndProp;
  bktex_prop: TBkTexProp;
  rgrid_prop: TRGridProp;
  sgrid_prop: TSGridProp;
  group_prop: TGroupProp;
  tlmap_prop: TTlMapProp;
  actor_prop: TActorProp;
  prtcl_prop: TPrtclProp;
  curve_prop: TCurveProp;

  {Object Default Properties}
  obj_default_prop: TObjInfo={$region -fold}
  (
    bkgnd_ptr                : Nil;
    bkgnd_width              : 0;
    bkgnd_height             : 0;
    rct_clp                  : (left  :0;
                                top   :0;
                                width :0;
                                height:0;
                                right :0;
                                bottom:0);
    g_ind                    : 0;
    k_ind                    : 0;
    t_ind                    : 0;
    anim_type                : ltStatic;
    koo                      : kooBkgnd;
    obj_show                 : True;
    abstract                 : True;
    movable                  : True;
    scalable                 : True;
    rotatable                : True;
    is_another_obj_kind_after: False;
    is_an_abst_obj_kind_after: False;
    local_axis               : (x:00; y:00);
    world_axis_shift         : (x:00; y:00);
    parallax_shift           : (x:16; y:16);
    obj_dist1                : 0;
    obj_dist2                : 0;
  ); {$endregion}

implementation

uses

  Main;

constructor TSceneTree.Create;                                                                                                                                                         {$ifdef Linux}[local];{$endif} {$region -fold}
begin
  global_prop :=obj_default_prop;
  curr_obj_ind:=0;
end; {$endregion}
destructor  TSceneTree.Destroy;                                                                                                                                                        {$ifdef Linux}[local];{$endif} {$region -fold}
begin
  self.Free;
  inherited Destroy;
end; {$endregion}
procedure   TSceneTree.FilEmpty;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin
end; {$endregion}
procedure   TSceneTree.FilBkgnd;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  srf_var_inst_ptr: PSurf=Nil;
begin
  srf_var_inst_ptr:=@srf_var;
  srf_var_inst_ptr^.FilBkgndObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.FilBkTex;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  tex_var_inst_ptr: PTex=Nil;
begin
  tex_var_inst_ptr:=@tex_var;
  tex_var_inst_ptr^.FilBkTexObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.FilRGrid;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  rgrd_var_inst_ptr: PRGrid=Nil;
begin
  rgrd_var_inst_ptr:=@rgr_var;
  rgrd_var_inst_ptr^.FilRGridObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.FilSGrid;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  sgrd_var_inst_ptr: PSGrid=Nil;
begin
  sgrd_var_inst_ptr:=@sgr_var;
  sgrd_var_inst_ptr^.FilSGridObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.FilGroup;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin
end; {$endregion}
procedure   TSceneTree.FilTlMap;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  tlm_var_inst_ptr: PTlMap=Nil;
begin
  tlm_var_inst_ptr:=Unaligned(@tlm_var);
  tlm_var_inst_ptr^.FilTileMapObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.FilActor;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin

end; {$endregion}
procedure   TSceneTree.FilPrtcl;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin

end; {$endregion}
procedure   TSceneTree.FilCurve;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  sln_var_inst_ptr: PCurve=Nil;
begin
  sln_var_inst_ptr:=Unaligned(@sln_var);
  sln_var_inst_ptr^.FilSplineObj(curr_obj_ind);
end; {$endregion}
procedure   TSceneTree.MovCurve;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  sln_var_inst_ptr: PCurve=Nil;
begin
  {sln_var_inst_ptr:=@sln_var;
  sln_var_inst_ptr^.MovSplineObj(obj_arr[curr_obj_ind].k_ind,...);}
end; {$endregion}
procedure   TSceneTree.FilScene;                                                                                                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      curr_obj_ind:=(obj_arr_ptr+obj_inds_arr_ptr^)^.k_ind;
      FilProc[obj_inds_arr_ptr^];
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.MovWorldAxisShiftRight;                                                                                                                                 inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.world_axis_shift.x-=(obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift.x;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.MovWorldAxisShiftLeft ;                                                                                                                                 inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.world_axis_shift.x+=(obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift.x;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.MovWorldAxisShiftDown ;                                                                                                                                 inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.world_axis_shift.y-=(obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift.y;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.MovWorldAxisShiftUp   ;                                                                                                                                 inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.world_axis_shift.y+=(obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift.x;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.SetWorldAxisShift     (world_axis_shift_:TPtPos);                                                                                                       inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.world_axis_shift:=world_axis_shift_;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.SetParallaxShift      (parallax_shift_  :TPtPos);                                                                                                       inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift:=parallax_shift_;
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.SetParallaxShift      (parallax_shift_  :TColor);                                                                                                       inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_arr_ptr     : PObjInfo;
  obj_inds_arr_ptr: PColor;
  i               : integer;
begin
  if (obj_cnt=0) then
    Exit;
  obj_arr_ptr     :=Unaligned(@obj_arr     [0]);
  obj_inds_arr_ptr:=Unaligned(@obj_inds_arr[0]);
  for i:=0 to obj_cnt-1 do
    begin
      (obj_arr_ptr+obj_inds_arr_ptr^)^.parallax_shift:=PtPos(parallax_shift_,parallax_shift_);
      Inc(obj_inds_arr_ptr);
    end;
end; {$endregion}
procedure   TSceneTree.SetFilProc            (abstract_:boolean; Proc0:TProc0; var obj_cnt_:TColor; var inds_obj_arr_,inds_sct_arr_:TColorArr);                                inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin
  Inc(obj_cnt_);
  SetLength(inds_obj_arr_,obj_cnt_);
  SetLength(inds_sct_arr_,obj_cnt_);
  inds_obj_arr_[obj_cnt_-1]  :=obj_cnt -1;
  obj_arr[obj_cnt-1].k_ind   :=obj_cnt_-1;
  obj_arr[obj_cnt-1].abstract:=abstract_;
  FilProc[obj_cnt-1]         :=Proc0;
end; {$endregion}
procedure   TSceneTree.Add                   (constref koo:TKindOfObject; constref world_axis_shift_:TPtPos);                                                                  inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  obj_var_ptr: PObjInfo;
begin
  Inc(obj_cnt);
  SetLength(FilProc     ,obj_cnt);
  SetLength(obj_arr     ,obj_cnt);
  SetLength(obj_inds_arr,obj_cnt);
  obj_var_ptr:=Unaligned(@obj_arr[obj_cnt-1]);
  obj_var_ptr^                 :=global_prop;
  obj_var_ptr^.g_ind           :=obj_cnt-1;
  obj_var_ptr^.koo             :=koo;
  obj_var_ptr^.world_axis_shift:=world_axis_shift_;
  case koo of
    kooEmpty: SetFilProc(True ,@FilEmpty,empty_cnt,empty_inds_obj_arr,empty_inds_sct_arr);
    kooBkgnd: SetFilProc(False,@FilBkgnd,bkgnd_cnt,bkgnd_inds_obj_arr,bkgnd_inds_sct_arr);
    kooBkTex: SetFilProc(False,@FilBkTex,bktex_cnt,bktex_inds_obj_arr,bktex_inds_sct_arr);
    kooRGrid: SetFilProc(False,@FilRGrid,rgrid_cnt,rgrid_inds_obj_arr,rgrid_inds_sct_arr);
    kooSGrid: SetFilProc(False,@FilSGrid,sgrid_cnt,sgrid_inds_obj_arr,sgrid_inds_sct_arr);
    kooGroup: SetFilProc(True ,@FilGroup,group_cnt,group_inds_obj_arr,group_inds_sct_arr);
    kooTlMap: SetFilProc(False,@FilTlMap,tlmap_cnt,tlmap_inds_obj_arr,tlmap_inds_sct_arr);
    kooActor: SetFilProc(False,@FilActor,actor_cnt,actor_inds_obj_arr,actor_inds_sct_arr);
    kooPrtcl: SetFilProc(False,@FilPrtcl,prtcl_cnt,prtcl_inds_obj_arr,prtcl_inds_sct_arr);
    kooCurve: SetFilProc(False,@FilCurve,curve_cnt,curve_inds_obj_arr,curve_inds_sct_arr);
  end;
  //CmpAllObjKindEqual(obj_cnt-1);
end; {$endregion}
procedure   TSceneTree.SetObjBkgnd           (constref obj_arr_ptr:PObjInfo; constref bkgnd_ptr:PInteger; constref bkgnd_width,bkgnd_height:TColor; constref rct_clp:TPtRect); inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin
  obj_arr_ptr^.bkgnd_ptr   :=bkgnd_ptr   ;
  obj_arr_ptr^.bkgnd_width :=bkgnd_width ;
  obj_arr_ptr^.bkgnd_height:=bkgnd_height;
  obj_arr_ptr^.rct_clp     :=rct_clp     ;
end; {$endregion}
// (Checks If Another Kind Of Object Is Available After Selected Object(From start_ind) In Objects array(obj_arr)) Проверяет есть ли другой вид обьектов после выбранного(начиная с start_ind) в иерархии сцены(scene tree):
function    TSceneTree.IsAnotherObjKindAfter (constref koo:TKindOfObject; constref start_ind:TColor=0): boolean;                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i: integer;
begin
  Result:=False;
  for i:=start_ind to Length(obj_arr)-1 do
    if (obj_arr[obj_inds_arr[i]].koo<>koo) then
      begin
        Result:=True;
        Break;
      end;
end; {$endregion}
function    TSceneTree.IsNotAbstObjKindAfter (constref koo:TKindOfObject; constref start_ind:TColor=0): boolean;                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i: integer;
begin
  Result:=False;
  for i:=start_ind to Length(obj_arr)-1 do
    if (obj_arr[obj_inds_arr[i]].koo<>koo) and (not (obj_arr[obj_inds_arr[i]].abstract)) then
      begin
        Result:=True;
        Break;
      end;
end; {$endregion}
function    TSceneTree.IsNotAbstObjKindAfter (                            constref start_ind:TColor=0): boolean;                                                               inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i: integer;
begin
  Result:=False;
  for i:=start_ind to Length(obj_arr)-1 do
    if (not (obj_arr[obj_inds_arr[i]].abstract)) then
      begin
        Result:=True;
        Break;
      end;
end; {$endregion}
// (Calculate Low Layer Objects Count) Подсчет количества обьектов "нижнего" слоя:
function    TSceneTree.LowLrObjCntCalc: TColor;                                                                                                                                inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i     : integer;
  p_s   : TPtPos;
begin
  Result:=Length(obj_inds_arr);
  p_s   :=obj_arr[obj_inds_arr[0]].parallax_shift;
  for i:=0 to Length(obj_arr)-1 do
    if (obj_arr[obj_inds_arr[i]].anim_type<>ltStatic) or (not (obj_arr[obj_inds_arr[i]].parallax_shift=p_s)) then
      begin
        Result:=i;
        Break;
      end;
end; {$endregion}
// (Check Equality Of Two Objects By Kind) Проверка на равенство двух обьектов по виду:
function    TSceneTree.AreTwoObjKindEqual    (constref obj_ind1,obj_ind2:TColor): boolean;                                                                                     inline; {$ifdef Linux}[local];{$endif} {$region -fold}
begin
  Result:=(obj_arr[obj_ind1].koo=obj_arr[obj_ind2].koo);
end; {$endregion}
//
function    TSceneTree.Min9(constref obj_inds_arr_:TColorArr; constref arr:TEdgeArr; constref max_item_val:TColor; constref item_cnt:TColor): TColor;                          inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i: integer;
begin
  Result:=max_item_val;
  for i:=0 to item_cnt-1 do
    if (obj_arr[obj_inds_arr_[arr[i].obj_ind]].t_ind<=Result) then
      Result:=obj_arr[obj_inds_arr_[arr[i].obj_ind]].t_ind;
end; {$endregion}
function    TSceneTree.Min9(constref obj_inds_arr_:TColorArr; constref arr:TSlPtArr; constref max_item_val:TColor; constref item_cnt:TColor): TColor;                          inline; {$ifdef Linux}[local];{$endif} {$region -fold}
var
  i: integer;
begin
  Result:=max_item_val;
  for i:=0 to item_cnt-1 do
    if (obj_arr[obj_inds_arr_[arr[i].obj_ind]].t_ind<=Result) then
      Result:=obj_arr[obj_inds_arr_[arr[i].obj_ind]].t_ind;
end; {$endregion}

end.