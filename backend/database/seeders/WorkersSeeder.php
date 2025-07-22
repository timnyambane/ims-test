<?php

namespace Database\Seeders;

use App\Models\Worker;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class WorkersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Worker::truncate();

        $workers = [
            ['name' => 'Alice Smith', 'email' => 'alice.smith@example.com'],
            ['name' => 'Bob Johnson', 'email' => 'bob.johnson@example.com'],
            ['name' => 'Charlie Brown', 'email' => 'charlie.brown@example.com'],
            ['name' => 'Diana Miller', 'email' => 'diana.miller@example.com'],
            ['name' => 'Eve Davis', 'email' => 'eve.davis@example.com'],
        ];

        foreach ($workers as $workerData) {
            Worker::create($workerData);
        }

        $this->command->info('5 workers seeded!');
    }
}
