// @ts-check
const { PrismaClient } = require('@prisma/client')

const prisma = new PrismaClient()

async function main() {
  const pin = await prisma.pin.upsert({
    where: {
      url: "https://www.electronforge.io/",
    },
    update:{},
    create: {
      url: "https://www.electronforge.io/",
      title:"Electron Forge",
      body: "a cool set of tools",
      ctime: new Date(),
      mtime: new Date()
    }
  })

  console.log({ pin })
}

main()
  .catch(e => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
