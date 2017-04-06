ERROR = zeros(10,4);
TIME = zeros(10,4);
TRADEOFF = zeros(10,3);
for nnnn = 1:10
    run load_orl_faces.m;
    ERROR(nnnn,:) = error;
    TIME(nnnn,:) = time;
    TRADEOFF(nnnn,:) = tradeoff;
end
    