function [ templateList ] = getAAL333List(  )
%GETAAL333TEMPLATE 此处显示有关此函数的摘要
%   此处显示详细说明
    templateList = [];
    
    load aal333
    x = 61;
    y = 73;
    z = 61;
    
    for i = 1 : 116
        template_i = [];
        for xi = 1 : x
            for yi = 1 : y
                for zi = 1 : z
                    if(aal333(xi,yi,zi) ~= i)
                        template_i(xi,yi,zi) = 0;
                    else
                        template_i(xi,yi,zi) = 1;
                    end
                end
            end
        end
        templateList(:,:,:,i) = template_i;
    end
    
end

function [ aal333Template ] = getAAL333Template()
%GETAAL333TEMPLATE 此处显示有关此函数的摘要
%   此处显示详细说明
    
    load aal333
    aal333Template = aal333;
    
end

