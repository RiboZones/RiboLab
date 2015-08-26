% drift_markov(p_start,N,generations)
%
% This function simulates genetic drift as a Markov process.  This is to say, a transition matrix is
% created where the Pr(i,j) defines the probability of change in a generation from the state i
% to the state j.  This transition matrix is created and the the population shifts between states
% according to their probability defined by the matrix.  This is not remarkable for producing a
% different outcome than genetic drift by sampling, but for producing the same outcome.
% Input initial p (p_start), population size (N), and number of generations (generations).
% Note that the population is a population of N haploids.
%
% Function written by Liam Revell 2005 for Matlab R12.

function drift_markov(p_start,N,generations)

% create the transition matrix
for i=0:N
    for j=0:N
        Pr(i+1,j+1)=(1/(factorial(N-i)*factorial(i)))*(j/N)^i*(1-j/N)^(N-i)*(factorial(N));
    end
end 

time(1)=0;
Ni=double(int32(p_start*N));
for i=2:generations
    test=0;
    while test==0
        % pick a new random frequency between 0 and N
        newNi=int32(rand*(N+1));
        % change to that state with the probability defined by Pr[N(i),N(i-1)]
        if Pr(double(newNi)+1,double(Ni(i-1))+1)>rand
            Ni(i)=newNi;
            test=1;
        end
    end
    time(i)=i-1;
end
p=Ni/N;

% plot p over time
plot(time,p,'k');
hold on;
axis([0 generations 0 1]);
xlabel('Time');
ylabel('p_A');
title('Drift as a Markov process');
