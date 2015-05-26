function tfout = elastix_cat(varargin)
% ELASTIX_CAT  Concatenation of elastix transforms.
%
% Elastix allows for a list of transforms to be applied to an image. For
% example, if we want to apply a translation transform followed by a
% B-spline transform, we can use
%
%   TF = 
% 
%                              Transform: 'BSplineTransform'
%                     NumberOfParameters: 84
%                    TransformParameters: [1x84 double]
%     InitialTransformParametersFileName: [1x1 struct]
%                 HowToCombineTransforms: 'Compose'
%
%   with
%
%   TF.InitialTransformParametersFileName = 
% 
%                              Transform: 'TranslationTransform'
%                     NumberOfParameters: 1
%                    TransformParameters: [1x2 double]
%    InitialTransformParametersFileName:  'NoInitialTransform'
%
%
% ELASTIX_CAT allows to concatenate a list of elastix transforms, each of
% which can be a simple transform or a list of transforms.
%
% TFOUT = ELASTIX_CAT(TF1, ..., TFN)
%
%   TF1, ..., TFN is a list of N elastix transforms, each being a struct,
%   that we want to apply to the image in that order. Each transform can be
%   simple, or be a concatenation of transforms using the
%   InitialTransformParametersFileName field.
%
%   TFOUT is a struct with TF1, ..., TFN concatenated:
%
%   TFOUT = TFN
%           TFN.InitialTransformParametersFileName = TF(N-1)
%               TF(N-1).InitialTransformParametersFileName = TF(N-2)
%                   ...
%                    TF1.InitialTransformParametersFileName = 'NoInitialTransform'

% Author: Ramon Casero <rcasero@gmail.com>
% Copyright © 2015 University of Oxford
% Version: 0.2.0
% $Rev$
% $Date$
% 
% University of Oxford means the Chancellor, Masters and Scholars of
% the University of Oxford, having an administrative office at
% Wellington Square, Oxford OX1 2JD, UK. 
%
% This file is part of Gerardus.
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details. The offer of this
% program under the terms of the License is subject to the License
% being interpreted in accordance with English Law and subject to any
% action against the University of Oxford being under the jurisdiction
% of the English Courts.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% check arguments
narginchk(1, Inf);
nargoutchk(0, 1);

% number of transforms to concatenate
N = length(varargin);

if (N == 0)
    
    tfout = [];
    return;
    
end

% start from the beginning
tfout = varargin{1};

% travel the list of transforms
for I = 2:N
    
    tfout = cat_2_transf(varargin{I}, tfout);
    
end

end

%% local functions

% cat_2_transf: add transform t2 at the end of transform t1
function t1 = cat_2_transf(t1, t2)

% look for the end 
str = 't1';
while (isstruct(eval([str '.InitialTransformParametersFileName'])))
    str = [str '.InitialTransformParametersFileName'];
end
eval([str '.InitialTransformParametersFileName = t2;']);

end