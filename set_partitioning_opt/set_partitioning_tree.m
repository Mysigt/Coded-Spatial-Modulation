function set_tree=set_partitioning_tree(H_ch,antennas)
     %antenna names, should have same amount of elements as tx number
C_st=Channel_State(antennas,H_ch);      %allocate each channel response matrix to the corresponding matrix name
mother_set=antennas';
tree_size=ceil(log2(length(antennas)));
set_tree=cell([tree_size 1]);
set_tree(1)={mother_set};
for i=1:tree_size-1
    
    child_branch=[];
    for j=1:2^(i-1)
        set=mother_set(j,:);
        opt_set=set_partitioning_opt(set,C_st);
        child_branch=cat(2,child_branch,opt_set');
    end
    set_tree(i+1)={child_branch};
    mother_set=child_branch';
end
end

function opt_set=set_partitioning_opt(set,C_st)
set=char(set);
max_set_size=ceil(length(set)/2);       %maximum possible size of a subset
max_sets=2;             %maximum number of sets
min_sets=1;             %minimum number of sets
min_set_size=max_set_size-1;         %minimum possible size of a subset


possible_sets=allPossibleCombinations(set, max_set_size,min_set_size); %calculate all possible subsets
Cost_Table=costTable(possible_sets,C_st);       %calculate cost of each subset in terms of mean euclidean distance of elements to each other
possible_sets=string(possible_sets);            %convert cell to string


prob=optimproblem('ObjectiveSense','minimize');     %initalize the optimization problem

%create optimization variable as if the subset is in use or not(logical 0
%or 1), naming subset state
set_used_state=optimvar('set_used_state',possible_sets,'Type', 'integer','LowerBound',0,'UpperBound',1);

%create the objective function which is cost sum of subsets
prob.Objective= sum(Cost_Table.*set_used_state);

%create constraints
const1=sum(set_used_state) <= max_sets;
const2=sum(set_used_state) >= min_sets;

%add constraints to the optimization problem
prob.Constraints.const1=const1;
prob.Constraints.const2=const2;

%create constraint array for ensuring each antenna to be placed in a subset
%and only in one subset
constraint_ary=optimconstr(length(set));
for i=1:length(set)
    constraint_ary(i)=sum(find_char(possible_sets,set(i)).*set_used_state)==1;
end

%add constraint array to the optimization problem
prob.Constraints.constraint_ary=constraint_ary;

sol = solve(prob);      %solve

set_partitioning_index=sol.set_used_state;      %get the subset state logicals

opt_set=possible_sets(logical(set_partitioning_index)); %get the corresponding subsets
end