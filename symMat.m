function M = symMat(N)

d = rand(N,1); % The diagonal values
t = triu(bsxfun(@min,d,d.').*rand(N),1); % The upper trianglar random values
M = diag(d)+t+t.'; % Put them together in a symmetric matrix