-- CreateEnum
CREATE TYPE "public"."NETWORK" AS ENUM ('Sepolia', 'Base');

-- CreateTable
CREATE TABLE "public"."TransactionDetails" (
    "_id" UUID NOT NULL,
    "txHash" TEXT NOT NULL,
    "isDone" BOOLEAN NOT NULL DEFAULT false,
    "tokenAddress" TEXT NOT NULL,
    "amount" TEXT NOT NULL,
    "sender" TEXT NOT NULL,
    "network" "public"."NETWORK" NOT NULL,
    "nonce" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TransactionDetails_pkey" PRIMARY KEY ("_id")
);

-- CreateTable
CREATE TABLE "public"."NetworkStatus" (
    "_id" UUID NOT NULL,
    "network" "public"."NETWORK" NOT NULL,
    "lastProcessedBlock" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NetworkStatus_pkey" PRIMARY KEY ("_id")
);

-- CreateTable
CREATE TABLE "public"."Nonce" (
    "_id" UUID NOT NULL,
    "nonce" INTEGER NOT NULL DEFAULT 0,
    "network" "public"."NETWORK" NOT NULL,

    CONSTRAINT "Nonce_pkey" PRIMARY KEY ("_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "TransactionDetails_txHash_key" ON "public"."TransactionDetails"("txHash");

-- CreateIndex
CREATE UNIQUE INDEX "NetworkStatus_network_key" ON "public"."NetworkStatus"("network");

-- CreateIndex
CREATE UNIQUE INDEX "Nonce_network_key" ON "public"."Nonce"("network");
