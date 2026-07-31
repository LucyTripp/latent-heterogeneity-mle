function [nodes, weights] = gauss_hermite_normal(n_nodes)
%GAUSS_HERMITE_NORMAL Nodes and weights for expectations under N(0,1).
%
% If Z ~ N(0,1), then E[f(Z)] is approximated by
% sum(weights .* f(sqrt(2) .* nodes)). The weights sum to one.

arguments
    n_nodes (1,1) double {mustBeInteger, mustBePositive}
end

off_diagonal = sqrt((1:n_nodes-1) / 2);
jacobi_matrix = diag(off_diagonal, 1) + diag(off_diagonal, -1);
[eigenvectors, eigenvalues] = eig(jacobi_matrix);
[nodes, order] = sort(diag(eigenvalues));
weights = eigenvectors(1, order)'.^2;
weights = weights / sum(weights);
end
