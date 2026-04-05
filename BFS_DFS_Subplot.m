function BFS_DFS_Subplot()

%% 参数设置
X_Length = 10;
Y_Length = 8;

Start_Node = [2,2];
Target_Node = [9,7];

Obs_Node_List = [[5,1];[5,2];[5,3];[5,4];[5,5];[6,5];[7,5]];

%% 运行 BFS 和 DFS
[path_bfs, visited_bfs] = BFS_Search(Start_Node,Target_Node,Obs_Node_List,X_Length,Y_Length);
[path_dfs, visited_dfs] = DFS_Search(Start_Node,Target_Node,Obs_Node_List,X_Length,Y_Length);

%% 画图
figure;

subplot(1,2,1);
DrawGrid(X_Length,Y_Length,Start_Node,Target_Node,Obs_Node_List,path_bfs,visited_bfs);
title('BFS');

subplot(1,2,2);
DrawGrid(X_Length,Y_Length,Start_Node,Target_Node,Obs_Node_List,path_dfs,visited_dfs);
title('DFS');

end

%% ================= BFS =================
function [path, visited] = BFS_Search(Start_Node,Target_Node,Obs_Node_List,X_Length,Y_Length)

visited = zeros(X_Length,Y_Length);
parent = zeros(X_Length,Y_Length,2);

queue = zeros(X_Length*Y_Length,2);
front = 1; rear = 1;

queue(rear,:) = Start_Node;
visited(Start_Node(1),Start_Node(2)) = 1;

dir = [1 0; -1 0; 0 1; 0 -1];
found = false;

while front <= rear
    current = queue(front,:);
    front = front + 1;

    if isequal(current,Target_Node)
        found = true;
        break;
    end

    for i = 1:4
        nx = current(1) + dir(i,1);
        ny = current(2) + dir(i,2);

        if nx<=0 || nx>X_Length || ny<=0 || ny>Y_Length
            continue;
        end

        if visited(nx,ny) == 1
            continue;
        end

        if ismember([nx ny],Obs_Node_List,'rows')
            continue;
        end

        queue(rear+1,:) = [nx ny];
        rear = rear + 1;

        visited(nx,ny) = 1;
        parent(nx,ny,:) = current;
    end
end

if found
    path = Target_Node;
    cur = Target_Node;

    while ~isequal(cur,Start_Node)
        px = parent(cur(1),cur(2),1);
        py = parent(cur(1),cur(2),2);
        cur = [px py];
        path = [cur; path];
    end
else
    path = [];
end

end

%% ================= DFS =================
function [path, visited] = DFS_Search(Start_Node,Target_Node,Obs_Node_List,X_Length,Y_Length)

visited = zeros(X_Length,Y_Length);
parent = zeros(X_Length,Y_Length,2);

stack = zeros(X_Length*Y_Length,2);
top = 1;

stack(top,:) = Start_Node;
visited(Start_Node(1),Start_Node(2)) = 1;

dir = [1 0; -1 0; 0 1; 0 -1];
found = false;

while top > 0
    current = stack(top,:);
    top = top - 1;

    if isequal(current,Target_Node)
        found = true;
        break;
    end

    for i = 1:4
        nx = current(1) + dir(i,1);
        ny = current(2) + dir(i,2);

        if nx<=0 || nx>X_Length || ny<=0 || ny>Y_Length
            continue;
        end

        if visited(nx,ny) == 1
            continue;
        end

        if ismember([nx ny],Obs_Node_List,'rows')
            continue;
        end

        stack(top+1,:) = [nx ny];
        top = top + 1;

        visited(nx,ny) = 1;
        parent(nx,ny,:) = current;
    end
end

if found
    path = Target_Node;
    cur = Target_Node;

    while ~isequal(cur,Start_Node)
        px = parent(cur(1),cur(2),1);
        py = parent(cur(1),cur(2),2);
        cur = [px py];
        path = [cur; path];
    end
else
    path = [];
end

end

%% ================= 绘图 =================
function DrawGrid(X_Length,Y_Length,Start_Node,Target_Node,Obs_Node_List,path,visited)

hold on;

% 网格
for x = 1:X_Length
    plot([x,x],[0,Y_Length],'k');
end
for y = 1:Y_Length
    plot([0,X_Length],[y,y],'k');
end

axis equal;
axis([0,X_Length,0,Y_Length]);

% 已探索节点（蓝色）🔥
for x = 1:X_Length
    for y = 1:Y_Length
        if visited(x,y) == 1
            if isequal([x y],Start_Node) || isequal([x y],Target_Node)
                continue;
            end
            fill([x,x,x-1,x-1],[y,y-1,y-1,y],'b');
        end
    end
end

% 障碍物
for i = 1:size(Obs_Node_List,1)
    x = Obs_Node_List(i,1);
    y = Obs_Node_List(i,2);
    fill([x,x,x-1,x-1],[y,y-1,y-1,y],'k');
end

% 起点
fill([Start_Node(1),Start_Node(1),Start_Node(1)-1,Start_Node(1)-1],...
     [Start_Node(2),Start_Node(2)-1,Start_Node(2)-1,Start_Node(2)],'y');

% 终点
fill([Target_Node(1),Target_Node(1),Target_Node(1)-1,Target_Node(1)-1],...
     [Target_Node(2),Target_Node(2)-1,Target_Node(2)-1,Target_Node(2)],'g');

% 路径
if ~isempty(path)
    plot(path(:,1)-0.5,path(:,2)-0.5,'r-*','LineWidth',2);
end

end