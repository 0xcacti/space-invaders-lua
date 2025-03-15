function all_dead(enemies)
    for _, enemy in ipairs(enemies) do
        if not enemy.is_dead then
            return false
        end
    end
    return true
end
