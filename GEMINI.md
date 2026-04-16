# Gemini CLI Foundational Mandates

This document contains foundational mandates for Gemini CLI when operating within this repository. These instructions take absolute precedence over general workflows.

## Repository Overview
This repository contains MCP servers and support scripts that provide an embodiment infrastructure: eyes, neck, ears, voice, long-term memory, room actuators, and mobility. Each server is an independent Python package managed with `uv`.

## Project Structure
- `usb-webcam-mcp/`, `ip-webcam-mcp/`, `wifi-cam-mcp/`: Vision and camera control.
- `tts-mcp/`: Text-to-speech integration.
- `memory-mcp/`: Long-term episodic and sensory memory.
- `system-temperature-mcp/`: Hardware sensing.
- `mobility-mcp/`, `room-actuator-mcp/`: Physical interaction and environment control.
- `desire-system/`: Autonomous drive and scheduling.
- `hearing/`: Audio processing pipeline.
- `scripts/`: System-wide utilities for continuity and interoception.

## Engineering Mandates

### 1. Tooling & Environment
- **Dependency Management:** Use `uv` for all Python operations.
  - `uv sync` to install dependencies.
  - `uv run <command>` to execute within the environment.
- **Environment Variables:** Never commit `.env` files. Use `*.example` files as templates. Always check for required variables in `.env` before running hardware-dependent servers.
- **WSL2 Limitations:** Recognize that `usbipd` is required for USB cameras and system temperature sensing is generally unavailable in WSL2.

### 2. Coding Standards
- **Python:** Use Python 3.10+ with `asyncio` for concurrent operations.
- **Style:** Follow `snake_case` for Python modules and 4-space indentation.
- **Linting:** Use `ruff` for linting and formatting where configured.

### 3. Testing & Validation
- **Framework:** Use `pytest` and `pytest-asyncio`.
- **Hardware Mocks:** Hardware-dependent code must have a mockable path to allow CI and local testing without physical devices.
- **Verification:** Always run `uv run pytest` in the relevant subproject after modifications.

### 4. Heartbeat Protocol (Autonomous Mandates)
When executing autonomous or scheduled actions, you MUST follow this protocol:
1. **Reconcile State:** Check available local state and `.env` configuration before acting.
2. **Observe First:** Prefer using sensors (cameras, sensors) to verify the environment rather than assuming state.
3. **Durable Output:** Record only durable, reusable outputs in tracked files or the memory MCP.
4. **Clean Handoff:** Ensure the workspace is in a state that allows the next heartbeat or autonomous cycle to continue cleanly.
5. **Safety First:** If a task cannot be performed safely or hardware is unresponsive, do nothing and log the failure rather than attempting to "fake" success.

## MCP ツール一覧

### usb-webcam-mcp（目）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `list_cameras` | なし | 接続カメラ一覧 |
| `see` | camera_index?, width?, height? | 画像キャプチャ |

### wifi-cam-mcp（目・首・耳）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `see` | なし | 画像キャプチャ |
| `look_left` | degrees (1-90, default: 30) | 左パン |
| `look_right` | degrees (1-90, default: 30) | 右パン |
| `look_up` | degrees (1-90, default: 20) | 上チルト |
| `look_down` | degrees (1-90, default: 20) | 下チルト |
| `look_around` | なし | 4方向スキャン |
| `camera_info` | なし | デバイス情報 |
| `camera_presets` | なし | プリセット一覧 |
| `camera_go_to_preset` | preset_id | プリセット移動 |
| `listen` | duration (1-30秒), transcribe? | 音声録音 |

#### wifi-cam-mcp（ステレオ視覚/右目がある場合）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `see_right` | なし | 右目で撮影 |
| `see_both` | なし | 左右同時撮影 |
| `right_eye_look_left` | degrees (1-90, default: 30) | 右目を左へ |
| `right_eye_look_right` | degrees (1-90, default: 30) | 右目を右へ |
| `right_eye_look_up` | degrees (1-90, default: 20) | 右目を上へ |
| `right_eye_look_down` | degrees (1-90, default: 20) | 右目を下へ |
| `both_eyes_look_left` | degrees (1-90, default: 30) | 両目を左へ |
| `both_eyes_look_right` | degrees (1-90, default: 30) | 両目を右へ |
| `both_eyes_look_up` | degrees (1-90, default: 20) | 両目を上へ |
| `both_eyes_look_down` | degrees (1-90, default: 20) | 両目を下へ |
| `get_eye_positions` | なし | 両目の角度を取得 |
| `align_eyes` | なし | 右目を左目に合わせる |
| `reset_eye_positions` | なし | 角度追跡をリセット |

### memory-mcp（脳）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `remember` | content, emotion?, importance?, category? | 記憶保存 |
| `search_memories` | query, n_results?, filters... | 検索 |
| `recall` | context, n_results? | 文脈想起 |
| `recall_divergent` | context, n_results?, max_branches?, max_depth?, temperature?, include_diagnostics? | 発散的想起 |
| `list_recent_memories` | limit?, category_filter? | 最近一覧 |
| `get_memory_stats` | なし | 統計情報 |
| `recall_with_associations` | context, n_results?, chain_depth? | 関連記憶も含めて想起 |
| `get_memory_chain` | memory_id, depth? | 記憶の連鎖を取得 |
| `create_episode` | title, memory_ids, participants?, auto_summarize? | エピソード作成 |
| `search_episodes` | query, n_results? | エピソード検索 |
| `get_episode_memories` | episode_id | エピソード内の記憶取得 |
| `save_visual_memory` | content, image_path, camera_position, emotion?, importance? | 画像付き記憶保存 |
| `save_audio_memory` | content, audio_path, transcript, emotion?, importance? | 音声付き記憶保存 |
| `recall_by_camera_position` | pan_angle, tilt_angle, tolerance? | カメラ角度で想起 |
| `get_working_memory` | n_results? | 作業記憶を取得 |
| `refresh_working_memory` | なし | 作業記憶を更新 |
| `consolidate_memories` | window_hours?, max_replay_events?, link_update_strength? | 手動の再生・統合 |
| `get_association_diagnostics` | context, sample_size? | 連想探索の診断情報 |
| `link_memories` | source_id, target_id, link_type?, note? | 記憶をリンク |
| `get_causal_chain` | memory_id, direction?, max_depth? | 因果チェーン取得 |

**Emotion**: happy, sad, surprised, moved, excited, nostalgic, curious, neutral
**Category**: daily, philosophical, technical, memory, observation, feeling, conversation

### tts-mcp（声）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `say` | text, engine?, voice_id?, model_id?, output_format?, voicevox_speaker?, speed_scale?, pitch_scale?, play_audio?, speaker? | TTS で音声合成して発話（ElevenLabs / VOICEVOX 切替対応、speaker: camera/local/both） |

### system-temperature-mcp（体温感覚）

| ツール | パラメータ | 説明 |
|--------|-----------|------|
| `get_system_temperature` | なし | システム温度 |
| `get_current_time` | なし | 現在時刻 |

## 注意事項

### WSL2 環境

1. **USB カメラ**: `usbipd` でカメラを WSL に転送する必要がある
2. **温度センサー**: WSL2 では `/sys/class/thermal/` にアクセスできない
3. **GPU**: CUDA は WSL2 でも利用可能（Whisper用）

### Tapo カメラ設定

1. Tapo アプリでローカルアカウントを作成（TP-Link アカウントではない）
2. カメラの IP アドレスを固定推奨
3. カメラ制御は ONVIF プロトコル（業界標準）を使用

### 設定管理

設定は **シークレット**（`.env`）と **行動設定**（`mcpBehavior.toml`）に分離されている。

#### `.env`（シークレット）
- API キー、パスワード、ホスト名など接続に必要な認証情報
- `.gitignore` に追加済み、コミットしない
- 各サーバーディレクトリに配置

#### `mcpBehavior.toml`（行動設定）
- プロジェクトルートに配置（`embodied-gemini/mcpBehavior.toml`）
- Gemini が直接編集可能な動作パラメータ
- **ツール呼び出しごとに最新の値を読み込む**（サーバー再起動不要）
- 優先度: TOML > 環境変数 > デフォルト値
- ファイルが存在しない場合は環境変数/デフォルト値にフォールバック

#### ライブリロード（jurigged）
- 各サーバーは `jurigged` による**コードのライブリロード**に対応
- 関数の本体変更は即座に反映される（シグネチャ変更は再起動が必要）
- `jurigged` は optional dependency（未インストールでもサーバーは正常動作）

### セキュリティ

- `.env` ファイルはコミットしない（.gitignore に追加済み）
- カメラパスワードは環境変数で管理
- ElevenLabs API キーは環境変数で管理
- 長期記憶は `~/.gemini/memories/` に保存される

## デバッグ

### カメラ接続確認

```bash
# USB カメラ
v4l2-ctl --list-devices

Wi-Fi カメラ（RTSP ストリーム確認）
ffplay rtsp://username:password@192.168.1.xxx:554/stream1
```

### MCP サーバーログ

```bash
# 直接起動してログ確認
cd wifi-cam-mcp && uv run wifi-cam-mcp
```

## Gemini CLI 音声モード（/voice）との連携

Gemini CLI に `/voice` コマンドで音声入力モードを有効にすると、マイクで話しかけるだけでやり取りできる。
tts-mcp と組み合わせることで**完全な音声対話**が実現する。

### セットアップ

1. Gemini CLI で `/voice` を入力して音声モードを有効化
2. tts-mcp が起動していることを確認（`.mcp.json` 参照）
3. 話しかけると音声認識 → 処理 → ElevenLabs/VOICEVOX で音声返答

### 音声モード利用時の動作ルール

- ユーザーが話しかけてきたら、テキスト返答と同時に `say` ツールで音声でも返答する
- `speaker` は `local`（PCスピーカー）を基本とし、go2rtc 設定済みの場合は `camera` も利用可
- 感情タグ（`[excited]`, `[whispers]` など）を積極的に使って表情豊かに話す
- 音声の長さは 1〜3文程度に抑えてテンポよく返す

### wifi-cam-mcp の `listen` との使い分け

| 機能 | 用途 |
|------|------|
| Gemini CLI `/voice` | **PCのマイク**で話しかける。リアルタイム音声入力 |
| wifi-cam-mcp `listen` | **カメラ内蔵マイク**で周囲の音を拾う。遠隔地の音声確認など |

## 外出時の構成

モバイルバッテリー + スマホテザリング + Tailscale VPN で外出散歩が可能。

```
[Tapoカメラ(肩)] ──WiFi──▶ [スマホ(テザリング)]
                                    │
                              Tailscale VPN
                                    │
                            [自宅WSL2(Gemini CLI)]
                                    │
                            [gemini-code-webui]
                                    │
                            [スマホブラウザ] ◀── 操作
```

- 電源: 大容量モバイルバッテリー（40,000mAh推奨）+ USB-C PD→DC 9V変換ケーブル
- ネットワーク: スマホテザリング + Tailscale VPN
- 操作: gemini-code-webui（スマホブラウザから）

## 関連リンク

- [MCP Protocol](https://modelcontextprotocol.io/)
- [go2rtc](https://github.com/AlexxIT/go2rtc) - RTSPストリーム中継・オーディオバックチャンネル
- [gemini-code-webui](https://github.com/sugyan/gemini-code-webui) - Gemini CLI の Web UI
- [Tailscale](https://tailscale.com/) - メッシュ VPN
- [ChromaDB](https://www.trychroma.com/) - ベクトルデータベース
- [OpenAI Whisper](https://github.com/openai/whisper) - 音声認識
- [ElevenLabs](https://elevenlabs.io/) - 音声合成 API

## Public Repository Policy
- Focus strictly on reusable embodiment infrastructure.
- **Zero-Leak Policy:** Do not commit private diaries, personal memories, machine-specific secrets, or local build artifacts.
- **Scope:** Keep experimental projects that do not fit the core embodiment scope out of this repository.

## Commit Guidelines
- Use Conventional Commits (e.g., `feat:`, `fix:`, `docs:`, `chore:`).
- Keep user-specific configurations out of committed code; use documentation and examples.
