-- ============================================
-- 员工个人发展计划填报 - Supabase建表SQL
-- ============================================

-- 1. 部门表
CREATE TABLE IF NOT EXISTS departments (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
);

-- 2. 员工发展计划表
CREATE TABLE IF NOT EXISTS development_plans (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  name TEXT NOT NULL,
  department TEXT NOT NULL,
  project_name TEXT,
  self_evaluation TEXT NOT NULL,
  development_path TEXT NOT NULL,
  goals JSONB NOT NULL DEFAULT '[]'::jsonb
);

-- 3. 插入12个部门初始数据
INSERT INTO departments (name, sort_order) VALUES
  ('监理项目部', 1),
  ('生产管理部', 2),
  ('技术服务事业部', 3),
  ('运营维护事业部', 4),
  ('经营部', 5),
  ('造价部', 6),
  ('招标代理事业部', 7),
  ('市场拓展部', 8),
  ('物业服务项目部', 9),
  ('餐饮服务项目部', 10),
  ('党政综合办', 11),
  ('财务部', 12)
ON CONFLICT (name) DO NOTHING;

-- 4. 启用行级安全（RLS）
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE development_plans ENABLE ROW LEVEL SECURITY;

-- 5. RLS策略：departments 允许匿名读取
DROP POLICY IF EXISTS "anon_select_departments" ON departments;
CREATE POLICY "anon_select_departments" ON departments
  FOR SELECT TO anon USING (true);

-- 6. RLS策略：development_plans 允许匿名插入
DROP POLICY IF EXISTS "anon_insert_development_plans" ON development_plans;
CREATE POLICY "anon_insert_development_plans" ON development_plans
  FOR INSERT TO anon WITH CHECK (true);

-- 7. RLS策略：development_plans 禁止匿名读取/修改/删除
-- 默认情况下 anon 角色无法 SELECT/UPDATE/DELETE（不创建策略即禁止）
