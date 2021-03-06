% zAnalyzePair(N1,N2,CL) computes distances, angles, and classification
% codes.

function [Pair] = zAnalyzePair(N1,N2,CL,Exemplar,Displ,Verbose)

  if nargin < 3,
    CL = zClassLimits;                              % read ClassLimits matrix

    if exist('PairExemplars.mat','file') > 0,
      load('PairExemplars','Exemplar');
    else
      Exemplar = [];
    end
  end

  if nargin < 5,
    Displ = (N2.Fit(1,:)-N1.Fit(1,:)) * N1.Rot;   % vector shift from 1 to 2
  end

  Pair.Paircode = 4*(N2.Code-1) + N1.Code;     % AA is 1, CA is 2, etc.

  Pair.Displ = Displ;                        % vector shift (from 1 to 2)

  ro = N1.Rot'*N2.Rot;                       % rotation matrix from 1 to 2
  Pair.Normal = ro(:,3)';                    % normal to second plane

  if ro(3,3) > 0,                            % depending on orientation of 2,
    [ax,ang] = zAxisAngle(ro);               % rotation angle without a flip
  else
    [ax,ang] = zAxisAngle(ro*diag([-1 1 -1])); % flip base 2 first
  end

  Pair.Rot      = ro;
  Pair.RotAx    = ax';
  Pair.Ang      = ang;

  Pair.PlaneAng = acos(abs(N1.Rot(:,3)'*N2.Rot(:,3)))*57.29577951308232; 
                                             % angle between planes

  Lim(2,:) = [15 13 16 12];     % total number of atoms, including hydrogen

  d = zDistance(N2.Fit(1:Lim(2,N2.Code),:), N1.Center); 
                                           % distances to base 1 center
  [y,m] = min(d);                          % identify the closest atom
  m = m(1);                                % in case of a tie, use the first
  Pair.Gap = N1.Rot(:,3)'*(N2.Fit(m,:)-N1.Center)';% height above plane of 1

  Pair.MinDist = min(min(zDistance(N1.Fit,N2.Fit)));

  a = zCheckCutoffs(Pair.Displ,Pair.Normal,Pair.Ang,Pair.Gap,CL(:,:,Pair.Paircode));
                                           % find possible classifications

  % ------------------------ check for coplanarity

  Pair.Coplanar = 0;                      % default value
  if (abs(Pair.Gap) < 2) && (Pair.MinDist < 5),
    v  = N1.Center - N2.Center;           % vector from center to center
    v  = v / norm(v);                     % normalize

    dot1 = abs(v * N1.Rot(:,3));          % to calculate angle: v and normal
    dot2 = abs(v * N2.Rot(:,3));

    yy = 0.5;

    if (dot1 < yy) && (dot2 < yy),         % angle > acos(yy) = 60 degrees

      d = zDistance(N1.Fit(1:Lim(2,N1.Code),:), N2.Center); 
                                           % distances to base 2 center
      [y,m] = min(d);                      % identify the closest atom
      m = m(1);                            % in case of a tie, use the first
      Gap2 = N2.Rot(:,3)'*(N1.Fit(m,:)-N2.Center)';% height above plane of 1

      if abs(Gap2) < 2,
        Pair.Coplanar = min([(2-abs(Pair.Gap))/2 (2-abs(Gap2))/2 (yy-dot1)/yy (yy-dot2)/yy min(1,5-Pair.MinDist)]);

      end
    end
  end

  % ---------- Notify and remove multiple classifications

  if length(a) > 1,
    if max(fix(a)) > min(fix(a)),              % different integer parts
      if Verbose > 1,
        fprintf('Bases %1s%5s(%1s) and %1s%5s(%1s) fall into categories ', N1.Base, N1.Number, N1.Chain, N2.Base, N2.Number, N2.Chain);
        for k=1:length(a),
          fprintf('%6.2f ',a(k));
        end
        fprintf('\n');
      end
      a = a(1);
    else
      a = sign(a(1))*min(abs(a));               % use primary version of class
    end
  end

  % ---------- Calculate hydrogen bonds for base pairing interactions

  if (abs(a) < 14),                           % if it appears to be a basepair
    Pair.Hydrogen = zCheckHydrogen(N1,N2,a);
  else
    Pair.Hydrogen = [];
  end

  % ---------- Eliminate out of plane interactions

  if (abs(a) < 11) || ((abs(a) >= 13) && (abs(a) < 14)),   % avoid cSS, tSS
    if length(Pair.Hydrogen) > 0,
      if abs(Pair.Gap) > 2.0,
        a = 30.1;
      end
    elseif abs(Pair.Gap) > 1.6,
      a = 30.2;
    end
  end

  % ---------- Eliminate bad hydrogen bonds

  if (abs(a)<14) && (abs(a) - fix(abs(a)) < 0.5),% standard planar interaction
    if (length(Pair.Hydrogen) > 0),             % with hydrogens to check
      goodhydrogens = 0;
      for h = 1:length(Pair.Hydrogen),
        if isempty(Pair.Hydrogen(h).Angle),     % no third atom available
          if Pair.Hydrogen(h).Distance <= 4.5,  % 
            goodhydrogens = goodhydrogens + 1;
          end
        else 
          if (Pair.Hydrogen(h).Angle >= 110)&&(Pair.Hydrogen(h).Distance <= 4),
            goodhydrogens = goodhydrogens + 1;
          end
        end
      end

      if goodhydrogens < length(Pair.Hydrogen),  % missing hydrogen bond
        gh = length(Pair.Hydrogen);              % required number

        if (length(Pair.Hydrogen) == 4),
          gh = 3;
        elseif (length(Pair.Hydrogen) == 3),
          gh = 2;
        end

        % Implement a few exceptions to hydrogen bonding rules

        if (fix(abs(a)) == 13) && (Pair.Paircode == 1)
          gh = 0;
        elseif (fix(a) == 13) && (Pair.Paircode == 5)
          gh = 0;
        elseif (fix(a) == -13) && (Pair.Paircode == 5)
          gh = 1;
        elseif (fix(abs(a)) == 13) && (Pair.Paircode == 6)
          gh = 1;
        elseif (fix(a) == 11) && (Pair.Paircode == 6)
          gh = 0;
        end
     
        if goodhydrogens < gh,
          a = 30.3;                              % reject this pair
        end
      end
    else

    end
  end

  % ---------- Measure stacking overlap

  SO1 = zStackingOverlap(N1,N2);
  SO2 = zStackingOverlap(N2,N1);

  if (SO1 > 0) && (SO2 > 0),
    Pair.StackingOverlap = (SO1+SO2)/2;
  else
    Pair.StackingOverlap = 0;
  end
  
  % ----------- Is an unclassified pair really stacked?

  if (fix(a) == 30) && (Pair.StackingOverlap > 0) && (Pair.MinDist < 4),
    if Pair.Displ(3) > 0,
      if Pair.Normal(3) > 0,
        a = 21;                       % second base above, pointing up
      else
        a = 22;                       % second base above, pointing down
      end
    else
      if Pair.Normal(3) > 0,
        a = -21;                      % second base below, pointing up
      else
        a = 23;                       % second base below, pointing down
      end
    end
  end

  % ----------- If classified as stacking, is there really overlap?

  if (fix(a) >= 21) && (fix(a) < 24) && (Pair.StackingOverlap == 0),
    a = 30;
%    if N1.Loc(1,1) < N2.Loc(1,1),     % only print each pair once
      % fprintf('Bases %1s%5s(%1s) and %1s%5s(%1s) have no stacking overlap\n', N1.Base, N1.Number, N1.Chain, N2.Base, N2.Number, N2.Chain);
%    end
  end

  % -------------------------- find distance to nearest exemplar

  if ~isempty(Exemplar),
    [c,d,ff,gg,h] = zDistanceToExemplars(Exemplar,N1,N2);
    Pair.Classes   = c(1:3);
    Pair.Distances = d(1:3);
  else
    Pair.Classes   = 99 * ones(1,3);
    Pair.Distances = 99999999 * ones(1,3);
  end

  % --------------------------- check hydrogen bonds if nearest exemplar
  % --------- is a basepair, even if this pair is far from that exemplar

  if (abs(a) >= 14) && (abs(Pair.Classes(1)) < 14),
    Pair.Hydrogen = zCheckHydrogen(N1,N2,Pair.Classes(1));
  end

  % ------------------------ record nearest exemplar if no classification yet

  if (fix(a) == 30),
    if (Pair.Distances(1) < 0.8) && (Pair.Normal(3) * Exemplar(ff(1),gg(1)).R(3,3) > 0), % same flip
      b = a-fix(a);                          % extract decimal code for reason
      c = Pair.Classes(1);
      a = sign(c) * (100 + abs(c) + b/1000);
    elseif (Pair.Distances(2) < 0.8) && (Pair.Normal(3) * Exemplar(ff(2),gg(2)).R(3,3) > 0), % same flip
      b = a-fix(a);                          % extract decimal code for reason
      c = Pair.Classes(2);
      a = sign(c) * (100 + abs(c) + b/1000);
    elseif (Pair.Distances(3) < 0.8) && (Pair.Normal(3) * Exemplar(ff(3),gg(3)).R(3,3) > 0), % same flip
      b = a-fix(a);                          % extract decimal code for reason
      c = Pair.Classes(3);
      a = sign(c) * (100 + abs(c) + b/1000);
    end
  end

  % ------------------------ store the classification

  Pair.Class = a;

  % ------------------------ store the edge information

  % reverse classification for GC and CG pairs, but why, exactly????

  if ((Pair.Paircode == 7) || (Pair.Paircode == 10)) && (abs(Pair.Class) < 14),
    Pair.Edge = -Pair.Class;
  else
    Pair.Edge = Pair.Class;
  end

  Pair.EdgeText = zEdgeText(Pair.Edge,1,Pair.Paircode);  % ever used?


