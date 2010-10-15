{**************************************************************************************************}
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is DMaps.DouglasPeuckers.pas.                                                        }
{                                                                                                  }
{ The Initial Developer of the Original Code is Nils Haeck (c) 2003 Simdesign (www.simdesign.nl).  }
{ Portions created by Wouter van Nifterick 2008-05-17 : added 2D float                             }
{**************************************************************************************************}

unit DelphiMaps.DouglasPeuckers;
{ Implementation of the famous Douglas-Peucker polyline simplification
  algorithm.

  This file contains a 3D floating point implementation, for spatial
  polylines, as well as a 2D integer implementation for use with
  Windows GDI.

  Loosely based on C code from SoftSurfer (www.softsurfer.com)
  http://geometryalgorithms.com/Archive/algorithm_0205/algorithm_0205.htm

  References:
  David Douglas & Thomas Peucker, "Algorithms for the reduction of the number of
  points required to represent a digitized line or its caricature", The Canadian
  Cartographer 10(2), 112-122  (1973)

  Delphi code by Nils Haeck (c) 2003 Simdesign (www.simdesign.nl)
  http://www.simdesign.nl/components/douglaspeucker.html
}


interface

uses
  Windows;

type

  // Generalized float and int types
  TFloat = double;

  // Float point 2D
  TPointFloat2D = packed record
    X: TFloat;
    Y: TFloat;
  end;

  // Float point 3D
  TPointFloat3D = packed record
    X: TFloat;
    Y: TFloat;
    Z: TFloat;
  end;

  TInt2dPointAr = array of TPoint;
  TFloat2DPointAr = array of TPointFloat2D;
  TFloat3DPointAr = array of TPointFloat3D;

  { PolySimplify:
    Approximates the polyline with vertices in Orig, with a simplified
    version that will be returned in Simple. The maximum deviation from the
    original line is given in Tol.
    Input:  Tol      = approximation tolerance
    Orig[]   = polyline array of vertex points
    Output: Simple[] = simplified polyline vertices. This array must initially
    have the same length as Orig
    Return: the number of points in Simple
  }
function PolySimplifyInt2D(Tol: TFloat; const Orig: array of TPoint; var Simple: TInt2dPointAr): integer;
function PolySimplifyFloat2D(Tol: TFloat; const Orig: array of TPointFloat2D; var Simple: TFloat2DPointAr): integer;
function PolySimplifyFloat3D(Tol: TFloat; const Orig: array of TPointFloat3D; var Simple: TFloat3DPointAr): integer;

procedure SimplifyFloat2D(var Tol2: TFloat; const Orig: array of TPointFloat2D; var Marker: array of boolean; j, k: integer);

implementation

uses Math;

function VecMinFloat2D(const A, B: TPointFloat2D): TPointFloat2D;
// Result = A - B
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

function VecMinFloat3D(const A, B: TPointFloat3D): TPointFloat3D;
// Result = A - B
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
end;

function DotProdFloat2D(const A, B: TPointFloat2D): TFloat;
// Dotproduct = A * B
begin
  Result := A.X * B.X + A.Y * B.Y;
end;

function DotProdFloat3D(const A, B: TPointFloat3D): TFloat;
// Dotproduct = A * B
begin
  Result := A.X * B.X + A.Y * B.Y + A.Z * B.Z;
end;

function NormSquaredFloat2D(const A: TPointFloat2D): TFloat;
// Square of the norm |A|
begin
  Result := A.X * A.X + A.Y * A.Y;
end;

function NormSquaredFloat3D(const A: TPointFloat3D): TFloat;
// Square of the norm |A|
begin
  Result := A.X * A.X + A.Y * A.Y + A.Z * A.Z;
end;

function DistSquaredFloat2D(const A, B: TPointFloat2D): TFloat;
// Square of the distance from A to B
begin
  Result := NormSquaredFloat2D(VecMinFloat2D(A, B));
end;

function DistSquaredFloat3D(const A, B: TPointFloat3D): TFloat;
// Square of the distance from A to B
begin
  Result := NormSquaredFloat3D(VecMinFloat3D(A, B));
end;

procedure SimplifyFloat2D(var Tol2: TFloat; const Orig: array of TPointFloat2D; var Marker: array of boolean; j, k: integer);
// Simplify polyline in OrigList between j and k. Marker[] will be set to True
// for each point that must be included
var
  i, MaxI: integer; // Index at maximum value
  MaxD2: TFloat; // Maximum value squared
  CU, CW, B: TFloat;
  DV2: TFloat;
  P0, P1, PB, U, W: TPointFloat2D;
begin
  // Is there anything to simplify?
  if k <= j + 1 then
    exit;

  P0 := Orig[j];
  P1 := Orig[k];
  U := VecMinFloat2D(P1, P0); // Segment vector
  CU := DotProdFloat2D(U, U); // Segment length squared
  MaxD2 := 0;
  MaxI := 0;

  // Loop through points and detect the one furthest away
  for i := j + 1 to k - 1 do
  begin
    W := VecMinFloat2D(Orig[i], P0);
    CW := DotProdFloat2D(W, U);

    // Distance of point Orig[i] from segment
    if CW <= 0 then
    begin
      // Before segment
      DV2 := DistSquaredFloat2D(Orig[i], P0)
    end
    else
    begin
      if CW > CU then
      begin
        // Past segment
        DV2 := DistSquaredFloat2D(Orig[i], P1);
      end
      else
      begin
        // Fraction of the segment
        if CU=0 then
          B := 0
        else
          B := CW / CU;
        PB.X := P0.X + B * U.X;
        PB.Y := P0.Y + B * U.Y;
        DV2 := DistSquaredFloat2D(Orig[i], PB);
      end;
    end;

    // test with current max distance squared
    if DV2 > MaxD2 then
    begin
      // Orig[i] is a new max vertex
      MaxI := i;
      MaxD2 := DV2;
    end;
  end;

  // If the furthest point is outside tolerance we must split
  if MaxD2 > Tol2 then
  begin // error is worse than the tolerance
    // split the polyline at the farthest vertex from S
    Marker[MaxI] := True; // mark Orig[maxi] for the simplified polyline

    // recursively simplify the two subpolylines at Orig[maxi]
    SimplifyFloat2D(Tol2, Orig, Marker, j, MaxI); // polyline Orig[j] to Orig[maxi]
    SimplifyFloat2D(Tol2, Orig, Marker, MaxI, k); // polyline Orig[maxi] to Orig[k]
  end;
end;

procedure SimplifyFloat3D(var Tol2: TFloat; const Orig: array of TPointFloat3D; var Marker: array of boolean; j, k: integer);
// Simplify polyline in OrigList between j and k. Marker[] will be set to True
// for each point that must be included
var
  i, MaxI: integer; // Index at maximum value
  MaxD2: TFloat; // Maximum value squared
  CU, CW, B: TFloat;
  DV2: TFloat;
  P0, P1, PB, U, W: TPointFloat3D;
begin
  // Is there anything to simplify?
  if k <= j + 1 then
    exit;

  P0 := Orig[j];
  P1 := Orig[k];
  U := VecMinFloat3D(P1, P0); // Segment vector
  CU := DotProdFloat3D(U, U); // Segment length squared
  MaxD2 := 0;
  MaxI := 0;

  // Loop through points and detect the one furthest away
  for i := j + 1 to k - 1 do
  begin
    W := VecMinFloat3D(Orig[i], P0);
    CW := DotProdFloat3D(W, U);

    // Distance of point Orig[i] from segment
    if CW <= 0 then
    begin
      // Before segment
      DV2 := DistSquaredFloat3D(Orig[i], P0)
    end
    else
    begin
      if CW > CU then
      begin
        // Past segment
        DV2 := DistSquaredFloat3D(Orig[i], P1);
      end
      else
      begin
        // Fraction of the segment
        if CU=0 then
          B := 0
        else
          B := CW / CU;
        PB.X := P0.X + B * U.X;
        PB.Y := P0.Y + B * U.Y;
        PB.Z := P0.Z + B * U.Z;
        DV2 := DistSquaredFloat3D(Orig[i], PB);
      end;
    end;

    // test with current max distance squared
    if DV2 > MaxD2 then
    begin
      // Orig[i] is a new max vertex
      MaxI := i;
      MaxD2 := DV2;
    end;
  end;

  // If the furthest point is outside tolerance we must split
  if MaxD2 > Tol2 then
  begin // error is worse than the tolerance

    // split the polyline at the farthest vertex from S
    Marker[MaxI] := True; // mark Orig[maxi] for the simplified polyline

    // recursively simplify the two subpolylines at Orig[maxi]
    SimplifyFloat3D(Tol2, Orig, Marker, j, MaxI); // polyline Orig[j] to Orig[maxi]
    SimplifyFloat3D(Tol2, Orig, Marker, MaxI, k); // polyline Orig[maxi] to Orig[k]
  end;
end;

function VecMinInt2D(const A, B: TPoint): TPoint;
// Result = A - B
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

function DotProdInt2D(const A, B: TPoint): TFloat;
// Dotproduct = A * B
begin
  Result := A.X * B.X + A.Y * B.Y;
end;

function NormSquaredInt2D(const A: TPoint): TFloat;
// Square of the norm |A|
begin
  Result := A.X * A.X + A.Y * A.Y;
end;

function DistSquaredInt2D(const A, B: TPoint): TFloat;
// Square of the distance from A to B
begin
  Result := NormSquaredInt2D(VecMinInt2D(A, B));
end;

procedure SimplifyInt2D(var Tol2: TFloat; const Orig: array of TPoint; var Marker: array of boolean; j, k: integer);
// Simplify polyline in OrigList between j and k. Marker[] will be set to True
// for each point that must be included
var
  i, MaxI: integer; // Index at maximum value
  MaxD2: TFloat; // Maximum value squared
  CU, CW, B: TFloat;
  DV2: TFloat;
  p0, p1, pB, U, W: TPoint;
begin
  // Is there anything to simplify?
  if k <= j + 1 then
    exit;

  p0 := Orig[j];
  p1 := Orig[k];
  U := VecMinInt2D(p1, p0); // Segment vector
  CU := DotProdInt2D(U, U); // Segment length squared
  MaxD2 := 0;
  MaxI := 0;

  // Loop through points and detect the one furthest away
  for i := j + 1 to k - 1 do
  begin
    W := VecMinInt2D(Orig[i], p0);
    CW := DotProdInt2D(W, U);

    // Distance of point Orig[i] from segment
    if CW <= 0 then
    begin
      // Before segment
      DV2 := DistSquaredInt2D(Orig[i], p0)
    end
    else
    begin
      if CW > CU then
      begin
        // Past segment
        DV2 := DistSquaredInt2D(Orig[i], p1);
      end
      else
      begin
        // Fraction of the segment
        if CU=0 then
          B := 0
        else
          B := CW / CU;
        pB.X := round(p0.X + B * U.X);
        pB.Y := round(p0.Y + B * U.Y);
        DV2 := DistSquaredInt2D(Orig[i], pB);
      end;
    end;

    // test with current max distance squared
    if DV2 > MaxD2 then
    begin
      // Orig[i] is a new max vertex
      MaxI := i;
      MaxD2 := DV2;
    end;
  end;

  // If the furthest point is outside tolerance we must split
  if MaxD2 > Tol2 then
  begin // error is worse than the tolerance

    // split the polyline at the farthest vertex from S
    Marker[MaxI] := True; // mark Orig[maxi] for the simplified polyline

    // recursively simplify the two subpolylines at Orig[maxi]
    SimplifyInt2D(Tol2, Orig, Marker, j, MaxI); // polyline Orig[j] to Orig[maxi]
    SimplifyInt2D(Tol2, Orig, Marker, MaxI, k); // polyline Orig[maxi] to Orig[k]

  end;
end;

function PolySimplifyFloat2D(Tol: TFloat; const Orig: array of TPointFloat2D; var Simple: TFloat2DPointAr): integer;
var
  i, N: integer;
  MarkerAr: array of boolean;
  Tol2: TFloat;
begin
  Result := 0;
  if length(Orig) < 2 then
    exit;
  Tol2 := sqr(Tol);

  // Create a marker array
  N := length(Orig);
  SetLength(MarkerAr, N);
  // Include first and last point
  MarkerAr[0] := True;
  MarkerAr[N - 1] := True;
  // Exclude intermediate for now
  for i := 1 to N - 2 do
    MarkerAr[i] := False;

  // Simplify
  SimplifyFloat2D(Tol2, Orig, MarkerAr, 0, N - 1);

  // prepare output list
  SetLength(Simple, N);
  for i := 0 to N - 1 do
  begin
    if MarkerAr[i] then
    begin
      Simple[Result] := Orig[i];
      inc(Result);
    end;
  end;
  // crop output list
  SetLength(Simple, Result);
end;

function PolySimplifyFloat3D(Tol: TFloat; const Orig: array of TPointFloat3D; var Simple: TFloat3DPointAr): integer;
var
  i, N: integer;
  Marker: array of boolean;
  Tol2: TFloat;
begin
  Result := 0;
  if length(Orig) < 2 then
    exit;
  Tol2 := sqr(Tol);

  // Create a marker array
  N := length(Orig);
  SetLength(Marker, N);
  // Include first and last point
  Marker[0] := True;
  Marker[N - 1] := True;
  // Exclude intermediate for now
  for i := 1 to N - 2 do
    Marker[i] := False;

  // Simplify
  SimplifyFloat3D(Tol2, Orig, Marker, 0, N - 1);

  // prepare output list
  SetLength(Simple, N);
  for i := 0 to N - 1 do
  begin
    if Marker[i] then
    begin
      Simple[Result] := Orig[i];
      inc(Result);
    end;
  end;
  // crop output list
  SetLength(Simple, Result);
end;

function PolySimplifyInt2D(Tol: TFloat; const Orig: array of TPoint; var Simple: TInt2dPointAr): integer;
var
  i, N: integer;
  Marker: array of boolean;
  Tol2: TFloat;
begin
  Result := 0;
  if length(Orig) < 2 then
    exit;
  Tol2 := sqr(Tol);

  // Create a marker array
  N := length(Orig);
  SetLength(Marker, N);
  // Include first and last point
  Marker[0] := True;
  Marker[N - 1] := True;
  // Exclude intermediate for now
  for i := 1 to N - 2 do
    Marker[i] := False;

  // Simplify
  SimplifyInt2D(Tol2, Orig, Marker, 0, N - 1);

  // Copy to resulting list

  // prepare output list
  SetLength(Simple, N);
  for i := 0 to N - 1 do
  begin
    if Marker[i] then
    begin
      Simple[Result] := Orig[i];
      inc(Result);
    end;
  end;
  // crop output list
  SetLength(Simple, Result);
end;

end.
