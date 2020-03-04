# STM32 Project Tools

This tool is used to create links to the following folders:  
1. ${STM32BASE}/firmware/stm32H743/examples/*/  
2. ${STM32BASE}/firmware/stm32L432/examples/*/  

```
./link_projects.sh
```

This tool is used to remove links to the following folders:  
1. ${STM32BASE}/firmware/stm32H743/examples/*/  
2. ${STM32BASE}/firmware/stm32L432/examples/*/  

```
./remove_project_links.sh
```

The following files are provided directly by the STM website and are very helpful.  

1. en.stm32cubeprog.zip  
  * This is the source code which includes drivers provided directly from the STM board manufacture.  
2. en.stsw-link007.zip  
  * This is the flashing tool that is provided directly from the STM board manufacture.  
