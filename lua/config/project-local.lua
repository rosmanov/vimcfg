-- Project-specific configuration loader
-- This module detects the current project and loads project-specific overrides

local M = {}

-- Get the current project root
function M.get_project_root()
  local cwd = vim.fn.getcwd()
  return cwd
end

-- Check if current directory is within a specific project path
function M.is_in_project(project_path)
  local cwd = vim.fn.getcwd()
  local expanded = vim.fn.expand(project_path)
  return string.find(cwd, expanded, 1, true) == 1
end

-- Load project-specific configuration
function M.load_project_config()
  -- Try to load local config
  local ok, local_config = pcall(require, "config.local")
  if not ok or not local_config.projects then
    return nil
  end

  -- Check each configured project
  for project_path, config in pairs(local_config.projects) do
    if M.is_in_project(project_path) then
      return config
    end
  end

  return nil
end

-- Get project-specific linter configuration
function M.get_linters_by_ft()
  local project_config = M.load_project_config()
  if project_config and project_config.linters_by_ft then
    return project_config.linters_by_ft
  end
  return nil
end

-- Get project-specific custom linter configurations
function M.get_custom_linters()
  local project_config = M.load_project_config()
  if project_config and project_config.custom_linters then
    return project_config.custom_linters
  end
  return nil
end

-- Get project-specific formatter configuration
function M.get_formatters_by_ft()
  local project_config = M.load_project_config()
  if project_config and project_config.formatters_by_ft then
    return project_config.formatters_by_ft
  end
  return nil
end

-- Get project-specific custom formatter configurations
function M.get_custom_formatters()
  local project_config = M.load_project_config()
  if project_config and project_config.custom_formatters then
    return project_config.custom_formatters
  end
  return nil
end

return M
