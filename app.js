import express from "express";
import { execSync } from "child_process";
import fs from "fs";
import yaml from "js-yaml";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import {
  KubeConfig,
  CoreV1Api,
  AppsV1Api,
  BatchV1Api,
} from "@kubernetes/client-node";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = express();
const port = 3000;
let sseCount = 0;

// 쿠버네티스 클라이언트 설정
const kc = new KubeConfig();
kc.loadFromCluster();
const coreApi = kc.makeApiClient(CoreV1Api);
const appsApi = kc.makeApiClient(AppsV1Api);
const batchApi = kc.makeApiClient(BatchV1Api);

app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));

// HTML 기본 페이지
app.get("/", (req, res) => {
  res.sendFile(join(__dirname, "public", "index.html"));
});

// SSE 환경 생성 요청 처리
app.post("/create", async (req, res) => {
  try {
    sseCount++;
    const ns = `sse${sseCount}`;

    // 네임스페이스 생성
    await coreApi.createNamespace({ metadata: { name: ns } });

    // 템플릿 로드 및 네임스페이스 삽입 (yaml 직접 적용 방식식)
    // const mongoYaml = yaml.loadAll(fs.readFileSync("manifests/mongo-replicaset-template.yaml", "utf8"));
    // const sseYaml = yaml.loadAll(fs.readFileSync("manifests/sse-deployment-template.yaml", "utf8"));
    // const allResources = [...mongoYaml, ...sseYaml];

    // for (const doc of allResources) {
    //   doc.metadata = doc.metadata || {};
    //   doc.metadata.namespace = ns;

    //   if (doc.kind === "Service") await coreApi.createNamespacedService(ns, doc);
    //   else if (doc.kind === "Deployment") await appsApi.createNamespacedDeployment(ns, doc);
    //   else if (doc.kind === "StatefulSet") await appsApi.createNamespacedStatefulSet(ns, doc);
    //   else if (doc.kind === "Job") await batchApi.createNamespacedJob(ns, doc);
    // }

    // Helm Chart로 Mongo + SSE 배포
    execSync(
      `helm install ${ns}-mongo ./helm-charts/mongo-rs --namespace ${ns}`,
      { stdio: "inherit" }
    );
    execSync(
      `helm install ${ns}-sse ./helm-charts/sse-service --namespace ${ns}`,
      { stdio: "inherit" }
    );

    res.send(
      `<p>✅ ${ns} 네임스페이스에 MongoDB + SSE 서비스가 생성되었습니다.</p><a href="/">돌아가기</a>`
    );
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .send(`<p>에러 발생: ${err.message}</p><a href="/">돌아가기</a>`);
  }
});

app.listen(port, () => {
  console.log(`✅ Console Web running on port ${port}`);
});
