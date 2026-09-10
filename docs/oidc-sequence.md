# OIDC token exchange sequence

1. A workload obtains an Entra-signed JWT from its native OIDC token endpoint. The JWT is audience-bound to the configured application and carries `iss`, `tid`, `sub`, and `aud`.
2. The workload sends the JWT to `https://sts.googleapis.com/v1/token` as a subject token using RFC 8693 token exchange. The WIF provider validates issuer, signature, audience, and the CEL attribute condition.
3. STS returns a short-lived federated access token representing the mapped WIF principal.
4. The principal calls IAM Credentials `generateAccessToken` through the service-account impersonation binding. No private key exists in the workload.
5. The resulting access token calls the target API, where the service account's resource-level role is enforced and logged.

The provider's CEL condition intentionally checks tenant and audience. In production, pin `google.subject` to a stable Entra subject or immutable object identifier and keep the condition narrower than a tenant-wide trust.
