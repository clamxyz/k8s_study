from flask import Flask,request
import json

# 创建app应用
app = Flask(__name__)

# 定制测试url
@app.route("/index")
def index():
  return "flask web ok\n"

@app.route('/image_check', methods=['POST'])
def image_policy():
  # 获取用户提交数据并进行数据反序列化
  post_data = request.get_data().decode()
  print("--- POST数据: {}".format(post_data))
  data = json.loads(post_data)
  # 定制容器镜像格式的检测规则 -- 必须携带标签
  for container in data['spec']['containers']:
    if ":" not in container['image'] or ":latest" in container['image']:
      msg="镜像格式检测失败! 镜像名称必须携带标签，同时禁用默认标签."
      allowed, reason = False, msg
      break
    else:
      msg="镜像格式检测成功!"
      allowed, reason = True, msg
  print("--- 检查结果: {}".format(reason))
  # 定制返回信息
  obj_api=data['apiVersion']
  obj_kind=data['kind']
  obj_image=data['spec']['containers'][0]['image']

  result = {"apiVersion": obj_api, "kind": obj_kind, "image_name": obj_image , "status": {"allowed": allowed, "reason": reason}}
  print("--- 响应数据: {}".format(result))
  # 对响应数据进行序列化操作，ensure_ascii=False，表示返回信息包含中文
  return json.dumps(result, ensure_ascii=False)

if __name__ == "__main__":
  app.run(host="0.0.0.0", port=8080, ssl_context=('/data/server/image_check/cert/webhook.pem', '/data/server/image_check/cert/webhook-key.pem'))
