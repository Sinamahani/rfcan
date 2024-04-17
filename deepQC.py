from codes_RF.dpqc_models import DeepQC

my_deepqc = DeepQC()                            #initialize the class
my_deepqc.load_data(label_keyword=["X5"])       #load the data into the class object (default; label_keyword="X5")
# my_deepqc.stats()                     

my_deepqc.add_shift(shift_factor=5)        #augment the data (default; noise_factor=40)
my_deepqc.add_scaling(scaling_factor=0.2)   #augment the data (default; low_pass=0.2)
my_deepqc.add_noise(noise_factor=0.01)      #augment the data (default; noise_factor=0.05)

kernel_sizes = [5]
lr = [1e-4]
decay = [1e-6]
batch_size = [256]
initializers = ['he_normal'] #, 'zeros', 'ones', 'random_uniform', 'random_normal', 'truncated_normal', 'glorot_normal', 'glorot_uniform', 'he_normal', 'he_uniform', 'lecun_uniform', 'lecun_normal']

exit_all_loop = False
for kernel_size in kernel_sizes:
    if exit_all_loop:
        break
    for init in initializers:
        if exit_all_loop:
            break
        for LR in zip(lr, decay):
            if exit_all_loop:
                break
            for batch in batch_size:
                print("="*100,"\n", "="*100)
                print("initializer:", init, "-- learning rate:", LR[0], "-- decay:", LR[1], "-- batch size:", batch, "-- kernel_size:", kernel_size)
                print("="*100,"\n", "="*100)
                
                
                acc = my_deepqc.train(model_type="unet", initializer=init, kernel_size = kernel_size, epochs= 100, batch_size= batch, verbose= 1, lr= LR[0], decay= LR[1],
                    plot_history= True, patience= 5, min_delta= 0.001, target_accuracy = 0.95)
                if acc > 0.97:
                    exit_all_loop = True
                    break