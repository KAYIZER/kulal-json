# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# The following custom nodes are listed under unknown_registry and could not be resolved because no aux_id (GitHub repo) was provided:
# - CheckpointLoaderSimple (no aux_id found) -> skipped
# - TextEncodeQwenImageEditPlus (no aux_id found) -> skipped
# - TextEncodeQwenImageEditPlus (no aux_id found) -> skipped
# - ConditioningZeroOut (no aux_id found) -> skipped

RUN git clone https://github.com/lrzjason/Comfyui-QwenEditUtils.git custom_nodes/Comfyui-QwenEditUtils

# install requirements for custom nodes
RUN pip install -r custom_nodes/Comfyui-QwenEditUtils/requirements.txt


# download models into comfyui
RUN comfy model download --url https://huggingface.co/Phr00t/Qwen-Image-Edit-Rapid-AIO/resolve/main/v21/Qwen-Rapid-AIO-NSFW-v21.safetensors --relative-path models/checkpoints --filename Qwen-Rapid-AIO-NSFW-v21.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors --relative-path models/clip --filename qwen_3_4b.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors --relative-path models/diffusion_models --filename z_image_turbo_bf16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors --relative-path models/vae --filename ae.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
