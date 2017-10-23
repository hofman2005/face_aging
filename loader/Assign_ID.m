function [id, id_hash_table] = Assign_ID(id, id_hash_table)
if id_hash_table(id) == 0
    id_hash_table(id) = max(id_hash_table) + 1;
end
id = id_hash_table(id);