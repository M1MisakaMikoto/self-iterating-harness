# CONTEXT.md — Agent Lab 词汇表

本文件只放术语定义，不包含实现细节、规范正文或决策记录（决策记录见 `serve_project/lab/docs/adr/`）。由 domain-modeling / grill-with-docs 在对话中就地更新，术语一确定即写入。

- **Agent Lab**：个人 agent 实验、文档规范与门户的集合。
- **实验（experiment）**：一个可复现的验证单元，包含目的、对照/步骤、指标、证据与结论；对应 `serve_project/lab/` 下一个实验子目录。
- **门户（portal）**：`serve_project/lab/index.html`，零依赖静态页面，是 lab 的导航入口。
- **证据（evidence）**：实验产生的可复核结果文件（JSON、日志、报告），用于支撑结论。
- **ADR（Architecture Decision Record）**：记录难以逆转、需要向未来读者解释的决策。
- **词汇表（glossary）**：本文件；术语先在此定义再在文档中使用。
- **控制面（control plane）**：调度中心，负责工作区/会话/对话的创建、事件记录、审批放行，并把任务派给某个 runner；不直接运行 agent。
- **Session Runner**：真正执行 agent 会话的常驻进程（运行 trae agent、调用模型与工具）。一个 runner 池可常驻 N 个、动态扩容到 N+M 个。
- **runner 注册与心跳**：runner 启动时向控制面报到并周期性上报存活与负载；控制面据此维护可用 runner 名单并挑选最空闲者派活。
- **执行编排层（Temporal）**：保障“任务派发—执行—暂停/恢复—重试”可靠性的层；控制面与 runner 仍各司其职，编排层负责进度与恢复。
- **会话工作区**：每个会话独占的工作目录；控制面在共享工作区根目录下创建，runner 只允许访问本会话目录。
- **开发栈（compose）**：本地开发/验收形态，用 Docker 运行与生产同一套程序（含编排层与 runner 池）；与生产的差异仅在托管与弹性方式。
- **候选池（candidate pool）**：某次运行中 agent 可见的 skill 集合，由会话/项目配置声明。
- **可用（available）**：skill 处于候选池中——agent 能看到它的 name 与 description，并可按需取用正文；**不等于**把 SKILL.md 全文注入 prompt。
- **skill 目录（catalog）**：候选池中每个 skill 的 name + description 列表，每轮注入 prompt 供 agent 挑选。
- **读取（read）**：agent 在运行中取用某个 skill 的 SKILL.md 正文的动作；是运行时可观测的事实（工具调用记录）。
- **采用（adopted）**：agent 读取某个 skill 后决定按它执行；**不强制**，读不等于用，是否采用由评测层判读。
- **注入（injected）**：真正进入模型上下文的内容；新模型下目录每轮注入，正文只在该 skill 被读取时按需进入。
